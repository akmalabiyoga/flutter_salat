import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../services/database/database.dart';
import '../services/bimas_islam_scraper.dart';
import '../models/jadwal_model.dart';
import '../services/database/database_provider.dart';
import '../services/notification_service.dart';

// Provider for BimasIslamScraper
final scraperProvider = Provider((ref) => BimasIslamScraper());

// Provider for ApiService
final apiServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  final scraper = ref.watch(scraperProvider);
  return ApiService(db, scraper);
});

// Provider for the configured City ID
final cityIdProvider = NotifierProvider<CityIdNotifier, String>(() {
  return CityIdNotifier();
});

class CityIdNotifier extends Notifier<String> {
  @override
  String build() {
    _loadCity();
    return ''; // Default empty, meaning user needs to select
  }

  Future<void> _loadCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString('city_id');
    if (savedCity != null && savedCity.isNotEmpty) {
      state = savedCity;
    }
  }

  Future<void> setCity(String newCityId) async {
    state = newCityId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('city_id', newCityId);
  }
}

// FutureProvider to fetch Jadwal based on current selected city and current date
final jadwalFutureProvider = FutureProvider.autoDispose<JadwalResponse>((
  ref,
) async {
  final cityId = ref.watch(cityIdProvider);
  if (cityId.isEmpty) {
    // If no city selected, return empty data
    return JadwalResponse(status: 0, message: 'No city selected', data: []);
  }

  final apiService = ref.watch(apiServiceProvider);

  // Format current date to YYYY-MM-DD
  final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  return apiService.fetchJadwal(cityId, currentDate);
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
final notificationSchedulerProvider = Provider.autoDispose((ref) {
  final jadwalAsync = ref.watch(jadwalFutureProvider);

  jadwalAsync.whenData((response) async {
    if (response.data.isNotEmpty) {
      final service = NotificationService();
      await service.cancelAll();
      
      for (int i = 0; i < response.data.length; i++) {
        final d = response.data[i];
        final dt = DateTime.tryParse(d.prayerTime);
        if (dt != null && dt.isAfter(DateTime.now())) {
          await service.scheduleNotification(
            id: i,
            title: 'Waktunya Sholat ${d.prayerName}',
            body: 'Waktunya sholat ${d.prayerName} untuk wilayah ${d.kabupatenKotaName}',
            scheduledDate: dt,
          );
        }
      }
    }
  });
  
  return null;
});
