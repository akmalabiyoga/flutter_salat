import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


part 'database.g.dart';

// Provinces Table
class Provinces extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// Cities Table
class Cities extends Table {
  TextColumn get id => text()();
  TextColumn get provinceId => text().references(Provinces, #id)();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// Jadwal Table
class Jadwal extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get cityId => text().references(Cities, #id)();
  TextColumn get date => text()(); // Format: YYYY-MM-DD
  TextColumn get imsak => text()();
  TextColumn get subuh => text()();
  TextColumn get terbit => text()();
  TextColumn get dhuha => text()();
  TextColumn get dzuhur => text()();
  TextColumn get ashar => text()();
  TextColumn get maghrib => text()();
  TextColumn get isya => text()();

  // Ensuring one schedule per city per date
  @override
  List<Set<Column>> get uniqueKeys => [{cityId, date}];
}

// Settings Table (to store user preference)
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Provinces, Cities, Jadwal, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Provinces
  Future<void> insertProvinces(List<ProvincesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(provinces, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<Province>> getAllProvinces() => select(provinces).get();

  // Cities
  Future<void> insertCities(List<CitiesCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(cities, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<City>> getCitiesByProvince(String provId) {
    return (select(cities)..where((tbl) => tbl.provinceId.equals(provId))).get();
  }

  // Jadwal
  Future<void> insertJadwalList(List<JadwalCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(jadwal, entries, mode: InsertMode.insertOrReplace);
    });
  }

  Future<List<JadwalData>> getJadwalByCityAndMonth(String cityId, String yearMonth) {
    // yearMonth is like '2026-05'
    return (select(jadwal)
          ..where((tbl) => tbl.cityId.equals(cityId))
          ..where((tbl) => tbl.date.like('$yearMonth-%')))
        .get();
  }

  // Settings
  Future<void> setSetting(String key, String value) {
    return into(settings).insert(
      SettingsCompanion.insert(key: key, value: value),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<String?> getSetting(String key) async {
    final query = select(settings)..where((tbl) => tbl.key.equals(key));
    final result = await query.getSingleOrNull();
    return result?.value;
  }

  Future<void> clearDatabase() async {
    await transaction(() async {
      await delete(jadwal).go();
      await delete(cities).go();
      await delete(provinces).go();
      await delete(settings).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pysalat.sqlite'));



    return NativeDatabase.createInBackground(file);
  });
}
