import 'package:intl/intl.dart';
import '../models/jadwal_model.dart' as legacy;
import 'database/database.dart';
import 'bimas_islam_scraper.dart';

class ApiService {
  final AppDatabase db;
  final BimasIslamScraper scraper;

  ApiService(this.db, this.scraper);

  Future<void> ensureProvincesLoaded() async {
    final provinces = await db.getAllProvinces();
    if (provinces.isEmpty) {
      final fetched = await scraper.fetchCookiesAndProvinces();
      final entries = fetched
          .map(
            (e) => ProvincesCompanion.insert(id: e['value']!, name: e['text']!),
          )
          .toList();
      await db.insertProvinces(entries);
    }
  }

  Future<void> ensureCitiesLoaded(String provinceId) async {
    final cities = await db.getCitiesByProvince(provinceId);
    if (cities.isEmpty) {
      final fetched = await scraper.fetchKabupatenKota(provinceId);
      final entries = fetched
          .map(
            (e) => CitiesCompanion.insert(
              id: e['value']!,
              provinceId: provinceId,
              name: e['name']!,
            ),
          )
          .toList();
      await db.insertCities(entries);
    }
  }

  Future<legacy.JadwalResponse> fetchJadwal(
    String citySlugOrId,
    String date,
  ) async {
    // If citySlugOrId doesn't match ID format (which is usually a short numeric string),
    // we would need to map the slug. But we'll assume we use cityId directly now from UI.
    // For legacy compat, if the UI still passes 'kabbogor', we'll need to fetch the real ID.
    // Since we'll update the UI, we'll assume citySlugOrId is the actual Drift DB city ID.

    final dt = DateTime.parse(date);
    final yearMonth = DateFormat('yyyy-MM').format(dt);

    List<JadwalData> localJadwal = await db.getJadwalByCityAndMonth(
      citySlugOrId,
      yearMonth,
    );

    if (localJadwal.isEmpty) {
      await _scrapeAndSaveMonth(citySlugOrId, dt.year, dt.month);
      localJadwal = await db.getJadwalByCityAndMonth(citySlugOrId, yearMonth);
    }

    // Convert to legacy flat list
    // We only want the specific date requested
    final singleDateJadwal = localJadwal.where((j) => j.date == date).toList();

    String cityName = '';
    String provName = '';
    try {
      final city = await (db.select(
        db.cities,
      )..where((t) => t.id.equals(citySlugOrId))).getSingle();
      cityName = city.name;
      final prov = await (db.select(
        db.provinces,
      )..where((t) => t.id.equals(city.provinceId))).getSingle();
      provName = prov.name;
    } catch (_) {}

    List<legacy.JadwalData> resultList = [];
    if (singleDateJadwal.isNotEmpty) {
      final day = singleDateJadwal.first;
      resultList = _flattenJadwal(day, cityName, provName);
    }

    // pre-scrape next month
    final nextMonthDt = DateTime(dt.year, dt.month + 1, 1);
    final nextYearMonth = DateFormat('yyyy-MM').format(nextMonthDt);
    db.getJadwalByCityAndMonth(citySlugOrId, nextYearMonth).then((nextJadwal) {
      if (nextJadwal.isEmpty) {
        _scrapeAndSaveMonth(citySlugOrId, nextMonthDt.year, nextMonthDt.month);
      }
    });

    return legacy.JadwalResponse(
      status: 1,
      message: 'Success',
      data: resultList,
    );
  }

  Future<void> _scrapeAndSaveMonth(String cityId, int year, int month) async {
    try {
      final city = await (db.select(
        db.cities,
      )..where((t) => t.id.equals(cityId))).getSingle();
      final provId = city.provinceId;

      final result = await scraper.fetchJadwalSholat(
        provId,
        cityId,
        month.toString(),
        year.toString(),
      );

      if ((result['status'] == true ||
              result['status'] == 1 ||
              result['status'] == '1') &&
          result['data'] != null) {
        final dataMap = result['data'] as Map<String, dynamic>;
        List<JadwalCompanion> toInsert = [];
        for (var entry in dataMap.entries) {
          final dayData = entry.value;
          toInsert.add(
            JadwalCompanion.insert(
              cityId: cityId,
              date: entry.key, // We use entry.key which is YYYY-MM-DD
              imsak: dayData['imsak'],
              subuh: dayData['subuh'],
              terbit: dayData['terbit'],
              dhuha: dayData['dhuha'],
              dzuhur: dayData['dzuhur'],
              ashar: dayData['ashar'],
              maghrib: dayData['maghrib'],
              isya: dayData['isya'],
            ),
          );
        }
        await db.insertJadwalList(toInsert);
      }
    } catch (e) {
      print('Error scraping month: \$e');
    }
  }

  List<legacy.JadwalData> _flattenJadwal(
    JadwalData day,
    String cityName,
    String provName,
  ) {
    final Map<String, String> times = {
      'Imsak': day.imsak,
      'Subuh': day.subuh,
      'Terbit': day.terbit,
      'Dhuha': day.dhuha,
      'Dzuhur': day.dzuhur,
      'Ashar': day.ashar,
      'Maghrib': day.maghrib,
      'Isya': day.isya,
    };

    return times.entries.map((e) {
      // Ensure we produce a valid DateTime format like "YYYY-MM-DDTHH:MM:00"
      String isoTime = "${day.date}T${e.value}:00";
      return legacy.JadwalData(
        prayerDate: day.date,
        prayerTime: isoTime,
        prayerName: e.key,
        kabupatenKotaName: cityName,
        provinsiName: provName,
      );
    }).toList();
  }
}
