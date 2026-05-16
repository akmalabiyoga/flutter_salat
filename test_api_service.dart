// import 'package:flutter_salat/services/api_service.dart';
// import 'package:flutter_salat/services/bimas_islam_scraper.dart';
// import 'package:flutter_salat/services/database/database.dart';
// import 'package:drift/native.dart';

// void main() async {
//   final db = AppDatabase(NativeDatabase.memory());
//   final scraper = BimasIslamScraper();
//   final api = ApiService(db, scraper);
  
//   try {
//     print('Loading provs...');
//     await api.ensureProvincesLoaded();
//     final provs = await db.getAllProvinces();
//     final provId = provs.first.id;
    
//     print('Loading cities for $provId...');
//     await api.ensureCitiesLoaded(provId);
//     final cities = await db.getCitiesByProvince(provId);
//     final cityId = cities.first.id;
    
//     print('Fetching jadwal for $cityId, 2025-01-01');
//     final response = await api.fetchJadwal(cityId, '2025-01-01');
//     print('Status: ${response.status}');
//     print('Message: ${response.message}');
//     print('Data length: ${response.data.length}');
//     if (response.data.isNotEmpty) {
//        print('First data: ${response.data.first.prayerName} - ${response.data.first.prayerTime}');
//     }
//   } catch(e) {
//     print('Error: $e');
//   } finally {
//     await db.close();
//   }
// }
