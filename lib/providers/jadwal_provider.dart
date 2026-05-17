import 'dart:async';
import 'dart:io';
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

    Future<void> updateWidgetData(List<PrayerTime> todayPrayerTimes) async {
      final now = DateTime.now();
      
      // Fetch yesterday's and tomorrow's to correctly handle day transitions
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));
      final tomorrowStr = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));
      
      final responseYesterday = await apiService.fetchJadwal(cityId, yesterdayStr);
      final responseTomorrow = await apiService.fetchJadwal(cityId, tomorrowStr);
      
      final List<PrayerTime> allPrayerTimes = [
        ...responseYesterday.data,
        ...todayPrayerTimes,
        ...responseTomorrow.data,
      ];

      PrayerTime? lastPrayer;
      PrayerTime? nextPrayer;
      Duration? minLastDuration;
      Duration? minNextDuration;

      for (final prayer in allPrayerTimes) {
        final timeObj = DateTime.tryParse(prayer.prayerTime);
        if (timeObj != null) {
          if (timeObj.isBefore(now)) {
            final diff = now.difference(timeObj);
            if (minLastDuration == null || diff < minLastDuration) {
              minLastDuration = diff;
              lastPrayer = prayer;
            }
          } else if (timeObj.isAfter(now)) {
            final diff = timeObj.difference(now);
            if (minNextDuration == null || diff < minNextDuration) {
              minNextDuration = diff;
              nextPrayer = prayer;
            }
          }
        }
      }

      String formatDuration(Duration duration) {
        int hours = duration.inHours;
        int minutes = duration.inMinutes.remainder(60);
        if (hours > 0) {
          return "${hours}h ${minutes}m";
        } else {
          return "${minutes}m";
        }
      }

      // Main widget display should ALWAYS be the NEXT prayer (showing time remaining)
      // Secondary widget display should ALWAYS be the LAST prayer (showing time elapsed)
      if (nextPrayer != null) {
        final nextTime = DateTime.parse(nextPrayer.prayerTime);
        final Duration remainingDiff = nextTime.difference(now);
        final String remainingStatus = "In ${formatDuration(remainingDiff)}";

        String secondaryText = "";
        if (lastPrayer != null) {
          final lastTime = DateTime.parse(lastPrayer.prayerTime);
          final Duration elapsedDiff = now.difference(lastTime);
          final String durationStr = formatDuration(elapsedDiff);
          secondaryText =
              "${lastPrayer.prayerName} ${DateFormat('HH:mm').format(lastTime)} • $durationStr ago";
        }

        print('Updating widget: ${nextPrayer.prayerName} $remainingStatus');
        await HomeWidget.saveWidgetData<String>('prayer_name', nextPrayer.prayerName);
        await HomeWidget.saveWidgetData<String>('prayer_time', DateFormat('HH:mm').format(nextTime));
        await HomeWidget.saveWidgetData<String>('prayer_status', remainingStatus);
        await HomeWidget.saveWidgetData<String>('secondary_prayer', secondaryText);
        final result = await HomeWidget.updateWidget(
          name: 'SalatWidgetProvider',
          androidName: 'SalatWidgetProvider',
        );
        print('Widget update result: $result');
      } else if (lastPrayer != null) {
        // Fallback if no next prayer is available
        final lastTime = DateTime.parse(lastPrayer.prayerTime);
        final Duration elapsedDiff = now.difference(lastTime);
        final String elapsedStatus = "${formatDuration(elapsedDiff)} ago";

        print('Updating widget fallback: ${lastPrayer.prayerName} $elapsedStatus');
        await HomeWidget.saveWidgetData<String>('prayer_name', lastPrayer.prayerName);
        await HomeWidget.saveWidgetData<String>('prayer_time', DateFormat('HH:mm').format(lastTime));
        await HomeWidget.saveWidgetData<String>('prayer_status', elapsedStatus);
        await HomeWidget.saveWidgetData<String>('secondary_prayer', '');
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

      if (Platform.isLinux) {
        // --- LINUX PLATFORM PATH ---
        // Linux uses Timers, so it only keeps the single NEXT prayer in memory.
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
                id: 0, // ID 0 for the single dynamic Linux timer
                title: 'Waktunya Sholat ${nextPrayer.prayerName}',
                body: 'Waktunya sholat ${nextPrayer.prayerName} untuk wilayah ${nextPrayer.kabupatenKotaName}',
                scheduledDate: dt,
              );
            } catch (e) {
              print('Error scheduling notification on Linux: $e');
            }
          }
        }
      } else {
        // --- ANDROID & OTHER PLATFORMS PATH (PRE-SCHEDULING) ---
        try {
          await service.cancelAll(); // Wipe all previously registered native alarms

          final Map<String, int> prayerIndices = {
            'Imsak': 0,
            'Subuh': 1,
            'Terbit': 2,
            'Dhuha': 3,
            'Dzuhur': 4,
            'Ashar': 5,
            'Maghrib': 6,
            'Isya': 7,
          };

          int scheduledCount = 0;

          // Pre-schedule the next 7 days (today + next 6 days)
          for (int i = 0; i < 7; i++) {
            final targetDate = now.add(Duration(days: i));
            final dateStr = DateFormat('yyyy-MM-dd').format(targetDate);
            final response = await apiService.fetchJadwal(cityId, dateStr);

            if (response.data.isEmpty) continue;

            final datePart = dateStr.replaceAll('-', '');
            final dateInt = int.tryParse(datePart) ?? 0;

            for (final prayer in response.data) {
              final dt = DateTime.tryParse(prayer.prayerTime);
              if (dt != null && dt.isAfter(now)) {
                final idx = prayerIndices[prayer.prayerName] ?? 9;
                final notificationId = dateInt * 10 + idx;

                await service.scheduleNotification(
                  id: notificationId,
                  title: 'Waktunya Sholat ${prayer.prayerName}',
                  body: 'Waktunya sholat ${prayer.prayerName} untuk wilayah ${prayer.kabupatenKotaName}',
                  scheduledDate: dt,
                );
                scheduledCount++;
              }
            }
          }
          print('Successfully pre-scheduled $scheduledCount prayers on Android.');
        } catch (e) {
          print('Error pre-scheduling notifications on Android: $e');
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
