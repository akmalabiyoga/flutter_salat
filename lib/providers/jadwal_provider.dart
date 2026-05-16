import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:home_widget/home_widget.dart';
import '../services/api_service.dart';
import '../services/database/database.dart';
import '../services/bimas_islam_scraper.dart';
import '../models/jadwal_model.dart';
import '../services/database/database_provider.dart';
import '../services/notification_service.dart';

// Provider for the currently viewed date (defaults to today)
final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(() {
  return SelectedDateNotifier();
});

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void nextDay() => state = state.add(const Duration(days: 1));
  void previousDay() => state = state.subtract(const Duration(days: 1));
  void setToday() => state = DateTime.now();
}


// Provider for BimasIslamScraper
final scraperProvider = Provider((ref) => BimasIslamScraper());

// Provider for ApiService
final apiServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  final scraper = ref.watch(scraperProvider);
  return ApiService(db, scraper);
});

// Provider for the configured City ID
final cityIdProvider = AsyncNotifierProvider<CityIdNotifier, String>(() {
  return CityIdNotifier();
});

class CityIdNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('city_id') ?? '';
  }

  Future<void> setCity(String newCityId) async {
    state = const AsyncLoading();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city_id', newCityId);
    state = AsyncData(newCityId);
  }
}

// FutureProvider to fetch Jadwal based on current selected city and current date
final jadwalFutureProvider = FutureProvider.autoDispose<JadwalResponse>((
  ref,
) async {
  // Properly wait for the cityId to be loaded from storage
  final cityId = await ref.watch(cityIdProvider.future);
  
  if (cityId.isEmpty) {
    // If no city selected, return empty data
    return JadwalResponse(status: 0, message: 'No city selected', data: []);
  }

  final selectedDate = ref.watch(selectedDateProvider);
  final apiService = ref.watch(apiServiceProvider);

  // Format date to YYYY-MM-DD
  final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

  final response = await apiService.fetchJadwal(cityId, dateStr);
  
  if (response.status == 0 && response.message == 'Invalid city') {
    // If the city ID is invalid (e.g. legacy slug), reset it to trigger re-config
    Future.microtask(() => ref.read(cityIdProvider.notifier).setCity(''));
  }
  
  return response;
});

// FutureProvider for Provinces
final provincesProvider = FutureProvider.autoDispose<List<Province>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  await apiService.ensureProvincesLoaded();
  final db = ref.watch(databaseProvider);
  return db.getAllProvinces();
});

// FutureProvider for Cities given a provinceId
final citiesProvider = FutureProvider.autoDispose.family<List<City>, String>((ref, provId) async {
  final apiService = ref.watch(apiServiceProvider);
  await apiService.ensureCitiesLoaded(provId);
  final db = ref.watch(databaseProvider);
  return db.getCitiesByProvince(provId);
});

// Provider to handle notification scheduling
final notificationSchedulerProvider = Provider((ref) {
  final cityIdAsync = ref.watch(cityIdProvider);
  if (cityIdAsync.isLoading) return null;
  
  final cityId = cityIdAsync.value ?? '';
  if (cityId.isEmpty) return null;

  final apiService = ref.watch(apiServiceProvider);
  final service = NotificationService();

    Future<void> updateWidgetData(List<PrayerTime> prayerTimes) async {
      final now = DateTime.now();
      int? lastPrayerIndex;
      int? nextPrayerIndex;
      Duration? minLastDuration;
      Duration? minNextDuration;

      for (int i = 0; i < prayerTimes.length; i++) {
        final timeObj = DateTime.tryParse(prayerTimes[i].prayerTime);
        if (timeObj != null) {
          if (timeObj.isBefore(now)) {
            final diff = now.difference(timeObj);
            if (minLastDuration == null || diff < minLastDuration) {
              minLastDuration = diff;
              lastPrayerIndex = i;
            }
          } else if (timeObj.isAfter(now)) {
            final diff = timeObj.difference(now);
            if (minNextDuration == null || diff < minNextDuration) {
              minNextDuration = diff;
              nextPrayerIndex = i;
            }
          }
        }
      }

      int? nearestPrayerIndex;
      if (minLastDuration != null && minNextDuration != null) {
        nearestPrayerIndex = minLastDuration < minNextDuration ? lastPrayerIndex : nextPrayerIndex;
      } else if (minLastDuration != null) {
        nearestPrayerIndex = lastPrayerIndex;
      } else if (minNextDuration != null) {
        nearestPrayerIndex = nextPrayerIndex;
      }

      if (nearestPrayerIndex != null) {
        final nearest = prayerTimes[nearestPrayerIndex];
        final nearestTime = DateTime.parse(nearest.prayerTime);

        String formatDuration(Duration duration) {
          int hours = duration.inHours;
          int minutes = duration.inMinutes.remainder(60);
          if (hours > 0) {
            return "${hours}h ${minutes}m";
          } else {
            return "${minutes}m";
          }
        }

        final bool nearestIsNext = nearestPrayerIndex == nextPrayerIndex;
        final Duration nearestDiff = nearestIsNext
            ? nearestTime.difference(now)
            : now.difference(nearestTime);
        final String nearestStatus = nearestIsNext
            ? "In ${formatDuration(nearestDiff)}"
            : "${formatDuration(nearestDiff)} ago";

        int? secondaryIndex;
        bool secondaryIsNext = false;
        if (nearestPrayerIndex == lastPrayerIndex) {
          secondaryIndex = nextPrayerIndex;
          secondaryIsNext = true;
        } else {
          secondaryIndex = lastPrayerIndex;
          secondaryIsNext = false;
        }

        String secondaryText = "";
        if (secondaryIndex != null) {
          final secondary = prayerTimes[secondaryIndex];
          final secondaryTime = DateTime.parse(secondary.prayerTime);
          final Duration secondaryDiff = secondaryIsNext
              ? secondaryTime.difference(now)
              : now.difference(secondaryTime);
          final String durationStr = formatDuration(secondaryDiff);
          secondaryText =
              "${secondary.prayerName} ${DateFormat('HH:mm').format(secondaryTime)} • ${secondaryIsNext ? 'In ' : ''}$durationStr${secondaryIsNext ? '' : ' ago'}";
        }

        print(
            'Updating widget: ${nearest.prayerName} $nearestStatus');
        await HomeWidget.saveWidgetData<String>(
            'prayer_name', nearest.prayerName);
        await HomeWidget.saveWidgetData<String>(
            'prayer_time', DateFormat('HH:mm').format(nearestTime));
        await HomeWidget.saveWidgetData<String>('prayer_status', nearestStatus);
        await HomeWidget.saveWidgetData<String>(
            'secondary_prayer', secondaryText);
        final result = await HomeWidget.updateWidget(
          name: 'SalatWidgetProvider',
          androidName: 'SalatWidgetProvider',
        );
        print('Widget update result: $result');
      }
    }

    Future<void> scheduleNext() async {
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      
      // Try today's schedule
      final responseToday = await apiService.fetchJadwal(cityId, todayStr);
      
      if (responseToday.data.isNotEmpty) {
        await updateWidgetData(responseToday.data);
      }

      PrayerTime? nextPrayer;
      for (final d in responseToday.data) {
        final dt = DateTime.tryParse(d.prayerTime);
        if (dt != null && dt.isAfter(now)) {
          nextPrayer = d;
          break;
        }
      }

      // If no more prayers today, try tomorrow
      if (nextPrayer == null) {
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowStr = DateFormat('yyyy-MM-dd').format(tomorrow);
        final responseTomorrow = await apiService.fetchJadwal(cityId, tomorrowStr);
        if (responseTomorrow.data.isNotEmpty) {
          nextPrayer = responseTomorrow.data.first;
        }
      }

      if (nextPrayer != null) {
        final dt = DateTime.tryParse(nextPrayer.prayerTime);
        if (dt != null) {
          try {
            await service.cancelAll();
            await service.scheduleNotification(
              id: 0, // We only ever have one scheduled
              title: 'Waktunya Sholat ${nextPrayer.prayerName}',
              body: 'Waktunya sholat ${nextPrayer.prayerName} untuk wilayah ${nextPrayer.kabupatenKotaName}',
              scheduledDate: dt,
            );
          } catch (e) {
            print('Error scheduling notification: $e');
          }
        }
      }
    }

  // Initial schedule
  scheduleNext();

  // Listen for notification fired events to schedule the next one
  final subscription = service.onNotificationFired.listen((_) {
    // Wait a bit to ensure the "now" is past the triggered time
    Future.delayed(const Duration(seconds: 5), () => scheduleNext());
  });

  ref.onDispose(() {
    subscription.cancel();
  });

  return null;
});
