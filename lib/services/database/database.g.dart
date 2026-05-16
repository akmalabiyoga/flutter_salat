// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProvincesTable extends Provinces
    with TableInfo<$ProvincesTable, Province> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvincesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provinces';
  @override
  VerificationContext validateIntegrity(
    Insertable<Province> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Province map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Province(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $ProvincesTable createAlias(String alias) {
    return $ProvincesTable(attachedDatabase, alias);
  }
}

class Province extends DataClass implements Insertable<Province> {
  final String id;
  final String name;
  const Province({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ProvincesCompanion toCompanion(bool nullToAbsent) {
    return ProvincesCompanion(id: Value(id), name: Value(name));
  }

  factory Province.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Province(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Province copyWith({String? id, String? name}) =>
      Province(id: id ?? this.id, name: name ?? this.name);
  Province copyWithCompanion(ProvincesCompanion data) {
    return Province(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Province(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Province && other.id == this.id && other.name == this.name);
}

class ProvincesCompanion extends UpdateCompanion<Province> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const ProvincesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProvincesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Province> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProvincesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return ProvincesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvincesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CitiesTable extends Cities with TableInfo<$CitiesTable, City> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provinceIdMeta = const VerificationMeta(
    'provinceId',
  );
  @override
  late final GeneratedColumn<String> provinceId = GeneratedColumn<String>(
    'province_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES provinces (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, provinceId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cities';
  @override
  VerificationContext validateIntegrity(
    Insertable<City> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('province_id')) {
      context.handle(
        _provinceIdMeta,
        provinceId.isAcceptableOrUnknown(data['province_id']!, _provinceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_provinceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  City map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return City(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      provinceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CitiesTable createAlias(String alias) {
    return $CitiesTable(attachedDatabase, alias);
  }
}

class City extends DataClass implements Insertable<City> {
  final String id;
  final String provinceId;
  final String name;
  const City({required this.id, required this.provinceId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['province_id'] = Variable<String>(provinceId);
    map['name'] = Variable<String>(name);
    return map;
  }

  CitiesCompanion toCompanion(bool nullToAbsent) {
    return CitiesCompanion(
      id: Value(id),
      provinceId: Value(provinceId),
      name: Value(name),
    );
  }

  factory City.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return City(
      id: serializer.fromJson<String>(json['id']),
      provinceId: serializer.fromJson<String>(json['provinceId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provinceId': serializer.toJson<String>(provinceId),
      'name': serializer.toJson<String>(name),
    };
  }

  City copyWith({String? id, String? provinceId, String? name}) => City(
    id: id ?? this.id,
    provinceId: provinceId ?? this.provinceId,
    name: name ?? this.name,
  );
  City copyWithCompanion(CitiesCompanion data) {
    return City(
      id: data.id.present ? data.id.value : this.id,
      provinceId: data.provinceId.present
          ? data.provinceId.value
          : this.provinceId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('City(')
          ..write('id: $id, ')
          ..write('provinceId: $provinceId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, provinceId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is City &&
          other.id == this.id &&
          other.provinceId == this.provinceId &&
          other.name == this.name);
}

class CitiesCompanion extends UpdateCompanion<City> {
  final Value<String> id;
  final Value<String> provinceId;
  final Value<String> name;
  final Value<int> rowid;
  const CitiesCompanion({
    this.id = const Value.absent(),
    this.provinceId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CitiesCompanion.insert({
    required String id,
    required String provinceId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provinceId = Value(provinceId),
       name = Value(name);
  static Insertable<City> custom({
    Expression<String>? id,
    Expression<String>? provinceId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provinceId != null) 'province_id': provinceId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CitiesCompanion copyWith({
    Value<String>? id,
    Value<String>? provinceId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CitiesCompanion(
      id: id ?? this.id,
      provinceId: provinceId ?? this.provinceId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provinceId.present) {
      map['province_id'] = Variable<String>(provinceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CitiesCompanion(')
          ..write('id: $id, ')
          ..write('provinceId: $provinceId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JadwalTable extends Jadwal with TableInfo<$JadwalTable, JadwalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JadwalTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cityIdMeta = const VerificationMeta('cityId');
  @override
  late final GeneratedColumn<String> cityId = GeneratedColumn<String>(
    'city_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cities (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imsakMeta = const VerificationMeta('imsak');
  @override
  late final GeneratedColumn<String> imsak = GeneratedColumn<String>(
    'imsak',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subuhMeta = const VerificationMeta('subuh');
  @override
  late final GeneratedColumn<String> subuh = GeneratedColumn<String>(
    'subuh',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _terbitMeta = const VerificationMeta('terbit');
  @override
  late final GeneratedColumn<String> terbit = GeneratedColumn<String>(
    'terbit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dhuhaMeta = const VerificationMeta('dhuha');
  @override
  late final GeneratedColumn<String> dhuha = GeneratedColumn<String>(
    'dhuha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dzuhurMeta = const VerificationMeta('dzuhur');
  @override
  late final GeneratedColumn<String> dzuhur = GeneratedColumn<String>(
    'dzuhur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _asharMeta = const VerificationMeta('ashar');
  @override
  late final GeneratedColumn<String> ashar = GeneratedColumn<String>(
    'ashar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maghribMeta = const VerificationMeta(
    'maghrib',
  );
  @override
  late final GeneratedColumn<String> maghrib = GeneratedColumn<String>(
    'maghrib',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isyaMeta = const VerificationMeta('isya');
  @override
  late final GeneratedColumn<String> isya = GeneratedColumn<String>(
    'isya',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cityId,
    date,
    imsak,
    subuh,
    terbit,
    dhuha,
    dzuhur,
    ashar,
    maghrib,
    isya,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jadwal';
  @override
  VerificationContext validateIntegrity(
    Insertable<JadwalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('city_id')) {
      context.handle(
        _cityIdMeta,
        cityId.isAcceptableOrUnknown(data['city_id']!, _cityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cityIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('imsak')) {
      context.handle(
        _imsakMeta,
        imsak.isAcceptableOrUnknown(data['imsak']!, _imsakMeta),
      );
    } else if (isInserting) {
      context.missing(_imsakMeta);
    }
    if (data.containsKey('subuh')) {
      context.handle(
        _subuhMeta,
        subuh.isAcceptableOrUnknown(data['subuh']!, _subuhMeta),
      );
    } else if (isInserting) {
      context.missing(_subuhMeta);
    }
    if (data.containsKey('terbit')) {
      context.handle(
        _terbitMeta,
        terbit.isAcceptableOrUnknown(data['terbit']!, _terbitMeta),
      );
    } else if (isInserting) {
      context.missing(_terbitMeta);
    }
    if (data.containsKey('dhuha')) {
      context.handle(
        _dhuhaMeta,
        dhuha.isAcceptableOrUnknown(data['dhuha']!, _dhuhaMeta),
      );
    } else if (isInserting) {
      context.missing(_dhuhaMeta);
    }
    if (data.containsKey('dzuhur')) {
      context.handle(
        _dzuhurMeta,
        dzuhur.isAcceptableOrUnknown(data['dzuhur']!, _dzuhurMeta),
      );
    } else if (isInserting) {
      context.missing(_dzuhurMeta);
    }
    if (data.containsKey('ashar')) {
      context.handle(
        _asharMeta,
        ashar.isAcceptableOrUnknown(data['ashar']!, _asharMeta),
      );
    } else if (isInserting) {
      context.missing(_asharMeta);
    }
    if (data.containsKey('maghrib')) {
      context.handle(
        _maghribMeta,
        maghrib.isAcceptableOrUnknown(data['maghrib']!, _maghribMeta),
      );
    } else if (isInserting) {
      context.missing(_maghribMeta);
    }
    if (data.containsKey('isya')) {
      context.handle(
        _isyaMeta,
        isya.isAcceptableOrUnknown(data['isya']!, _isyaMeta),
      );
    } else if (isInserting) {
      context.missing(_isyaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {cityId, date},
  ];
  @override
  JadwalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JadwalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      imsak: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imsak'],
      )!,
      subuh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subuh'],
      )!,
      terbit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}terbit'],
      )!,
      dhuha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dhuha'],
      )!,
      dzuhur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dzuhur'],
      )!,
      ashar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ashar'],
      )!,
      maghrib: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maghrib'],
      )!,
      isya: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isya'],
      )!,
    );
  }

  @override
  $JadwalTable createAlias(String alias) {
    return $JadwalTable(attachedDatabase, alias);
  }
}

class JadwalData extends DataClass implements Insertable<JadwalData> {
  final int id;
  final String cityId;
  final String date;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  const JadwalData({
    required this.id,
    required this.cityId,
    required this.date,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['city_id'] = Variable<String>(cityId);
    map['date'] = Variable<String>(date);
    map['imsak'] = Variable<String>(imsak);
    map['subuh'] = Variable<String>(subuh);
    map['terbit'] = Variable<String>(terbit);
    map['dhuha'] = Variable<String>(dhuha);
    map['dzuhur'] = Variable<String>(dzuhur);
    map['ashar'] = Variable<String>(ashar);
    map['maghrib'] = Variable<String>(maghrib);
    map['isya'] = Variable<String>(isya);
    return map;
  }

  JadwalCompanion toCompanion(bool nullToAbsent) {
    return JadwalCompanion(
      id: Value(id),
      cityId: Value(cityId),
      date: Value(date),
      imsak: Value(imsak),
      subuh: Value(subuh),
      terbit: Value(terbit),
      dhuha: Value(dhuha),
      dzuhur: Value(dzuhur),
      ashar: Value(ashar),
      maghrib: Value(maghrib),
      isya: Value(isya),
    );
  }

  factory JadwalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JadwalData(
      id: serializer.fromJson<int>(json['id']),
      cityId: serializer.fromJson<String>(json['cityId']),
      date: serializer.fromJson<String>(json['date']),
      imsak: serializer.fromJson<String>(json['imsak']),
      subuh: serializer.fromJson<String>(json['subuh']),
      terbit: serializer.fromJson<String>(json['terbit']),
      dhuha: serializer.fromJson<String>(json['dhuha']),
      dzuhur: serializer.fromJson<String>(json['dzuhur']),
      ashar: serializer.fromJson<String>(json['ashar']),
      maghrib: serializer.fromJson<String>(json['maghrib']),
      isya: serializer.fromJson<String>(json['isya']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cityId': serializer.toJson<String>(cityId),
      'date': serializer.toJson<String>(date),
      'imsak': serializer.toJson<String>(imsak),
      'subuh': serializer.toJson<String>(subuh),
      'terbit': serializer.toJson<String>(terbit),
      'dhuha': serializer.toJson<String>(dhuha),
      'dzuhur': serializer.toJson<String>(dzuhur),
      'ashar': serializer.toJson<String>(ashar),
      'maghrib': serializer.toJson<String>(maghrib),
      'isya': serializer.toJson<String>(isya),
    };
  }

  JadwalData copyWith({
    int? id,
    String? cityId,
    String? date,
    String? imsak,
    String? subuh,
    String? terbit,
    String? dhuha,
    String? dzuhur,
    String? ashar,
    String? maghrib,
    String? isya,
  }) => JadwalData(
    id: id ?? this.id,
    cityId: cityId ?? this.cityId,
    date: date ?? this.date,
    imsak: imsak ?? this.imsak,
    subuh: subuh ?? this.subuh,
    terbit: terbit ?? this.terbit,
    dhuha: dhuha ?? this.dhuha,
    dzuhur: dzuhur ?? this.dzuhur,
    ashar: ashar ?? this.ashar,
    maghrib: maghrib ?? this.maghrib,
    isya: isya ?? this.isya,
  );
  JadwalData copyWithCompanion(JadwalCompanion data) {
    return JadwalData(
      id: data.id.present ? data.id.value : this.id,
      cityId: data.cityId.present ? data.cityId.value : this.cityId,
      date: data.date.present ? data.date.value : this.date,
      imsak: data.imsak.present ? data.imsak.value : this.imsak,
      subuh: data.subuh.present ? data.subuh.value : this.subuh,
      terbit: data.terbit.present ? data.terbit.value : this.terbit,
      dhuha: data.dhuha.present ? data.dhuha.value : this.dhuha,
      dzuhur: data.dzuhur.present ? data.dzuhur.value : this.dzuhur,
      ashar: data.ashar.present ? data.ashar.value : this.ashar,
      maghrib: data.maghrib.present ? data.maghrib.value : this.maghrib,
      isya: data.isya.present ? data.isya.value : this.isya,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JadwalData(')
          ..write('id: $id, ')
          ..write('cityId: $cityId, ')
          ..write('date: $date, ')
          ..write('imsak: $imsak, ')
          ..write('subuh: $subuh, ')
          ..write('terbit: $terbit, ')
          ..write('dhuha: $dhuha, ')
          ..write('dzuhur: $dzuhur, ')
          ..write('ashar: $ashar, ')
          ..write('maghrib: $maghrib, ')
          ..write('isya: $isya')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cityId,
    date,
    imsak,
    subuh,
    terbit,
    dhuha,
    dzuhur,
    ashar,
    maghrib,
    isya,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JadwalData &&
          other.id == this.id &&
          other.cityId == this.cityId &&
          other.date == this.date &&
          other.imsak == this.imsak &&
          other.subuh == this.subuh &&
          other.terbit == this.terbit &&
          other.dhuha == this.dhuha &&
          other.dzuhur == this.dzuhur &&
          other.ashar == this.ashar &&
          other.maghrib == this.maghrib &&
          other.isya == this.isya);
}

class JadwalCompanion extends UpdateCompanion<JadwalData> {
  final Value<int> id;
  final Value<String> cityId;
  final Value<String> date;
  final Value<String> imsak;
  final Value<String> subuh;
  final Value<String> terbit;
  final Value<String> dhuha;
  final Value<String> dzuhur;
  final Value<String> ashar;
  final Value<String> maghrib;
  final Value<String> isya;
  const JadwalCompanion({
    this.id = const Value.absent(),
    this.cityId = const Value.absent(),
    this.date = const Value.absent(),
    this.imsak = const Value.absent(),
    this.subuh = const Value.absent(),
    this.terbit = const Value.absent(),
    this.dhuha = const Value.absent(),
    this.dzuhur = const Value.absent(),
    this.ashar = const Value.absent(),
    this.maghrib = const Value.absent(),
    this.isya = const Value.absent(),
  });
  JadwalCompanion.insert({
    this.id = const Value.absent(),
    required String cityId,
    required String date,
    required String imsak,
    required String subuh,
    required String terbit,
    required String dhuha,
    required String dzuhur,
    required String ashar,
    required String maghrib,
    required String isya,
  }) : cityId = Value(cityId),
       date = Value(date),
       imsak = Value(imsak),
       subuh = Value(subuh),
       terbit = Value(terbit),
       dhuha = Value(dhuha),
       dzuhur = Value(dzuhur),
       ashar = Value(ashar),
       maghrib = Value(maghrib),
       isya = Value(isya);
  static Insertable<JadwalData> custom({
    Expression<int>? id,
    Expression<String>? cityId,
    Expression<String>? date,
    Expression<String>? imsak,
    Expression<String>? subuh,
    Expression<String>? terbit,
    Expression<String>? dhuha,
    Expression<String>? dzuhur,
    Expression<String>? ashar,
    Expression<String>? maghrib,
    Expression<String>? isya,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cityId != null) 'city_id': cityId,
      if (date != null) 'date': date,
      if (imsak != null) 'imsak': imsak,
      if (subuh != null) 'subuh': subuh,
      if (terbit != null) 'terbit': terbit,
      if (dhuha != null) 'dhuha': dhuha,
      if (dzuhur != null) 'dzuhur': dzuhur,
      if (ashar != null) 'ashar': ashar,
      if (maghrib != null) 'maghrib': maghrib,
      if (isya != null) 'isya': isya,
    });
  }

  JadwalCompanion copyWith({
    Value<int>? id,
    Value<String>? cityId,
    Value<String>? date,
    Value<String>? imsak,
    Value<String>? subuh,
    Value<String>? terbit,
    Value<String>? dhuha,
    Value<String>? dzuhur,
    Value<String>? ashar,
    Value<String>? maghrib,
    Value<String>? isya,
  }) {
    return JadwalCompanion(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      date: date ?? this.date,
      imsak: imsak ?? this.imsak,
      subuh: subuh ?? this.subuh,
      terbit: terbit ?? this.terbit,
      dhuha: dhuha ?? this.dhuha,
      dzuhur: dzuhur ?? this.dzuhur,
      ashar: ashar ?? this.ashar,
      maghrib: maghrib ?? this.maghrib,
      isya: isya ?? this.isya,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cityId.present) {
      map['city_id'] = Variable<String>(cityId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (imsak.present) {
      map['imsak'] = Variable<String>(imsak.value);
    }
    if (subuh.present) {
      map['subuh'] = Variable<String>(subuh.value);
    }
    if (terbit.present) {
      map['terbit'] = Variable<String>(terbit.value);
    }
    if (dhuha.present) {
      map['dhuha'] = Variable<String>(dhuha.value);
    }
    if (dzuhur.present) {
      map['dzuhur'] = Variable<String>(dzuhur.value);
    }
    if (ashar.present) {
      map['ashar'] = Variable<String>(ashar.value);
    }
    if (maghrib.present) {
      map['maghrib'] = Variable<String>(maghrib.value);
    }
    if (isya.present) {
      map['isya'] = Variable<String>(isya.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JadwalCompanion(')
          ..write('id: $id, ')
          ..write('cityId: $cityId, ')
          ..write('date: $date, ')
          ..write('imsak: $imsak, ')
          ..write('subuh: $subuh, ')
          ..write('terbit: $terbit, ')
          ..write('dhuha: $dhuha, ')
          ..write('dzuhur: $dzuhur, ')
          ..write('ashar: $ashar, ')
          ..write('maghrib: $maghrib, ')
          ..write('isya: $isya')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProvincesTable provinces = $ProvincesTable(this);
  late final $CitiesTable cities = $CitiesTable(this);
  late final $JadwalTable jadwal = $JadwalTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    provinces,
    cities,
    jadwal,
    settings,
  ];
}

typedef $$ProvincesTableCreateCompanionBuilder =
    ProvincesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$ProvincesTableUpdateCompanionBuilder =
    ProvincesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

final class $$ProvincesTableReferences
    extends BaseReferences<_$AppDatabase, $ProvincesTable, Province> {
  $$ProvincesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CitiesTable, List<City>> _citiesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cities,
    aliasName: $_aliasNameGenerator(db.provinces.id, db.cities.provinceId),
  );

  $$CitiesTableProcessedTableManager get citiesRefs {
    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.provinceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_citiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProvincesTableFilterComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> citiesRefs(
    Expression<bool> Function($$CitiesTableFilterComposer f) f,
  ) {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvincesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProvincesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProvincesTable> {
  $$ProvincesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> citiesRefs<T extends Object>(
    Expression<T> Function($$CitiesTableAnnotationComposer a) f,
  ) {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.provinceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvincesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProvincesTable,
          Province,
          $$ProvincesTableFilterComposer,
          $$ProvincesTableOrderingComposer,
          $$ProvincesTableAnnotationComposer,
          $$ProvincesTableCreateCompanionBuilder,
          $$ProvincesTableUpdateCompanionBuilder,
          (Province, $$ProvincesTableReferences),
          Province,
          PrefetchHooks Function({bool citiesRefs})
        > {
  $$ProvincesTableTableManager(_$AppDatabase db, $ProvincesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvincesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvincesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvincesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProvincesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => ProvincesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProvincesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({citiesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (citiesRefs) db.cities],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (citiesRefs)
                    await $_getPrefetchedData<Province, $ProvincesTable, City>(
                      currentTable: table,
                      referencedTable: $$ProvincesTableReferences
                          ._citiesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProvincesTableReferences(db, table, p0).citiesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.provinceId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProvincesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProvincesTable,
      Province,
      $$ProvincesTableFilterComposer,
      $$ProvincesTableOrderingComposer,
      $$ProvincesTableAnnotationComposer,
      $$ProvincesTableCreateCompanionBuilder,
      $$ProvincesTableUpdateCompanionBuilder,
      (Province, $$ProvincesTableReferences),
      Province,
      PrefetchHooks Function({bool citiesRefs})
    >;
typedef $$CitiesTableCreateCompanionBuilder =
    CitiesCompanion Function({
      required String id,
      required String provinceId,
      required String name,
      Value<int> rowid,
    });
typedef $$CitiesTableUpdateCompanionBuilder =
    CitiesCompanion Function({
      Value<String> id,
      Value<String> provinceId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$CitiesTableReferences
    extends BaseReferences<_$AppDatabase, $CitiesTable, City> {
  $$CitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProvincesTable _provinceIdTable(_$AppDatabase db) => db.provinces
      .createAlias($_aliasNameGenerator(db.cities.provinceId, db.provinces.id));

  $$ProvincesTableProcessedTableManager get provinceId {
    final $_column = $_itemColumn<String>('province_id')!;

    final manager = $$ProvincesTableTableManager(
      $_db,
      $_db.provinces,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_provinceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$JadwalTable, List<JadwalData>> _jadwalRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.jadwal,
    aliasName: $_aliasNameGenerator(db.cities.id, db.jadwal.cityId),
  );

  $$JadwalTableProcessedTableManager get jadwalRefs {
    final manager = $$JadwalTableTableManager(
      $_db,
      $_db.jadwal,
    ).filter((f) => f.cityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_jadwalRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CitiesTableFilterComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$ProvincesTableFilterComposer get provinceId {
    final $$ProvincesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableFilterComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> jadwalRefs(
    Expression<bool> Function($$JadwalTableFilterComposer f) f,
  ) {
    final $$JadwalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jadwal,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JadwalTableFilterComposer(
            $db: $db,
            $table: $db.jadwal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProvincesTableOrderingComposer get provinceId {
    final $$ProvincesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableOrderingComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CitiesTable> {
  $$CitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$ProvincesTableAnnotationComposer get provinceId {
    final $$ProvincesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.provinceId,
      referencedTable: $db.provinces,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvincesTableAnnotationComposer(
            $db: $db,
            $table: $db.provinces,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> jadwalRefs<T extends Object>(
    Expression<T> Function($$JadwalTableAnnotationComposer a) f,
  ) {
    final $$JadwalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.jadwal,
      getReferencedColumn: (t) => t.cityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JadwalTableAnnotationComposer(
            $db: $db,
            $table: $db.jadwal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CitiesTable,
          City,
          $$CitiesTableFilterComposer,
          $$CitiesTableOrderingComposer,
          $$CitiesTableAnnotationComposer,
          $$CitiesTableCreateCompanionBuilder,
          $$CitiesTableUpdateCompanionBuilder,
          (City, $$CitiesTableReferences),
          City,
          PrefetchHooks Function({bool provinceId, bool jadwalRefs})
        > {
  $$CitiesTableTableManager(_$AppDatabase db, $CitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> provinceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CitiesCompanion(
                id: id,
                provinceId: provinceId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String provinceId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => CitiesCompanion.insert(
                id: id,
                provinceId: provinceId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CitiesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({provinceId = false, jadwalRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (jadwalRefs) db.jadwal],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (provinceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.provinceId,
                                referencedTable: $$CitiesTableReferences
                                    ._provinceIdTable(db),
                                referencedColumn: $$CitiesTableReferences
                                    ._provinceIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (jadwalRefs)
                    await $_getPrefetchedData<City, $CitiesTable, JadwalData>(
                      currentTable: table,
                      referencedTable: $$CitiesTableReferences._jadwalRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$CitiesTableReferences(db, table, p0).jadwalRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cityId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CitiesTable,
      City,
      $$CitiesTableFilterComposer,
      $$CitiesTableOrderingComposer,
      $$CitiesTableAnnotationComposer,
      $$CitiesTableCreateCompanionBuilder,
      $$CitiesTableUpdateCompanionBuilder,
      (City, $$CitiesTableReferences),
      City,
      PrefetchHooks Function({bool provinceId, bool jadwalRefs})
    >;
typedef $$JadwalTableCreateCompanionBuilder =
    JadwalCompanion Function({
      Value<int> id,
      required String cityId,
      required String date,
      required String imsak,
      required String subuh,
      required String terbit,
      required String dhuha,
      required String dzuhur,
      required String ashar,
      required String maghrib,
      required String isya,
    });
typedef $$JadwalTableUpdateCompanionBuilder =
    JadwalCompanion Function({
      Value<int> id,
      Value<String> cityId,
      Value<String> date,
      Value<String> imsak,
      Value<String> subuh,
      Value<String> terbit,
      Value<String> dhuha,
      Value<String> dzuhur,
      Value<String> ashar,
      Value<String> maghrib,
      Value<String> isya,
    });

final class $$JadwalTableReferences
    extends BaseReferences<_$AppDatabase, $JadwalTable, JadwalData> {
  $$JadwalTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CitiesTable _cityIdTable(_$AppDatabase db) => db.cities.createAlias(
    $_aliasNameGenerator(db.jadwal.cityId, db.cities.id),
  );

  $$CitiesTableProcessedTableManager get cityId {
    final $_column = $_itemColumn<String>('city_id')!;

    final manager = $$CitiesTableTableManager(
      $_db,
      $_db.cities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JadwalTableFilterComposer
    extends Composer<_$AppDatabase, $JadwalTable> {
  $$JadwalTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imsak => $composableBuilder(
    column: $table.imsak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subuh => $composableBuilder(
    column: $table.subuh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get terbit => $composableBuilder(
    column: $table.terbit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dhuha => $composableBuilder(
    column: $table.dhuha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dzuhur => $composableBuilder(
    column: $table.dzuhur,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ashar => $composableBuilder(
    column: $table.ashar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isya => $composableBuilder(
    column: $table.isya,
    builder: (column) => ColumnFilters(column),
  );

  $$CitiesTableFilterComposer get cityId {
    final $$CitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableFilterComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JadwalTableOrderingComposer
    extends Composer<_$AppDatabase, $JadwalTable> {
  $$JadwalTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imsak => $composableBuilder(
    column: $table.imsak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subuh => $composableBuilder(
    column: $table.subuh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get terbit => $composableBuilder(
    column: $table.terbit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dhuha => $composableBuilder(
    column: $table.dhuha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dzuhur => $composableBuilder(
    column: $table.dzuhur,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ashar => $composableBuilder(
    column: $table.ashar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maghrib => $composableBuilder(
    column: $table.maghrib,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isya => $composableBuilder(
    column: $table.isya,
    builder: (column) => ColumnOrderings(column),
  );

  $$CitiesTableOrderingComposer get cityId {
    final $$CitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableOrderingComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JadwalTableAnnotationComposer
    extends Composer<_$AppDatabase, $JadwalTable> {
  $$JadwalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get imsak =>
      $composableBuilder(column: $table.imsak, builder: (column) => column);

  GeneratedColumn<String> get subuh =>
      $composableBuilder(column: $table.subuh, builder: (column) => column);

  GeneratedColumn<String> get terbit =>
      $composableBuilder(column: $table.terbit, builder: (column) => column);

  GeneratedColumn<String> get dhuha =>
      $composableBuilder(column: $table.dhuha, builder: (column) => column);

  GeneratedColumn<String> get dzuhur =>
      $composableBuilder(column: $table.dzuhur, builder: (column) => column);

  GeneratedColumn<String> get ashar =>
      $composableBuilder(column: $table.ashar, builder: (column) => column);

  GeneratedColumn<String> get maghrib =>
      $composableBuilder(column: $table.maghrib, builder: (column) => column);

  GeneratedColumn<String> get isya =>
      $composableBuilder(column: $table.isya, builder: (column) => column);

  $$CitiesTableAnnotationComposer get cityId {
    final $$CitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cityId,
      referencedTable: $db.cities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.cities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JadwalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JadwalTable,
          JadwalData,
          $$JadwalTableFilterComposer,
          $$JadwalTableOrderingComposer,
          $$JadwalTableAnnotationComposer,
          $$JadwalTableCreateCompanionBuilder,
          $$JadwalTableUpdateCompanionBuilder,
          (JadwalData, $$JadwalTableReferences),
          JadwalData,
          PrefetchHooks Function({bool cityId})
        > {
  $$JadwalTableTableManager(_$AppDatabase db, $JadwalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JadwalTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JadwalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JadwalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cityId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> imsak = const Value.absent(),
                Value<String> subuh = const Value.absent(),
                Value<String> terbit = const Value.absent(),
                Value<String> dhuha = const Value.absent(),
                Value<String> dzuhur = const Value.absent(),
                Value<String> ashar = const Value.absent(),
                Value<String> maghrib = const Value.absent(),
                Value<String> isya = const Value.absent(),
              }) => JadwalCompanion(
                id: id,
                cityId: cityId,
                date: date,
                imsak: imsak,
                subuh: subuh,
                terbit: terbit,
                dhuha: dhuha,
                dzuhur: dzuhur,
                ashar: ashar,
                maghrib: maghrib,
                isya: isya,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cityId,
                required String date,
                required String imsak,
                required String subuh,
                required String terbit,
                required String dhuha,
                required String dzuhur,
                required String ashar,
                required String maghrib,
                required String isya,
              }) => JadwalCompanion.insert(
                id: id,
                cityId: cityId,
                date: date,
                imsak: imsak,
                subuh: subuh,
                terbit: terbit,
                dhuha: dhuha,
                dzuhur: dzuhur,
                ashar: ashar,
                maghrib: maghrib,
                isya: isya,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$JadwalTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({cityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cityId,
                                referencedTable: $$JadwalTableReferences
                                    ._cityIdTable(db),
                                referencedColumn: $$JadwalTableReferences
                                    ._cityIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JadwalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JadwalTable,
      JadwalData,
      $$JadwalTableFilterComposer,
      $$JadwalTableOrderingComposer,
      $$JadwalTableAnnotationComposer,
      $$JadwalTableCreateCompanionBuilder,
      $$JadwalTableUpdateCompanionBuilder,
      (JadwalData, $$JadwalTableReferences),
      JadwalData,
      PrefetchHooks Function({bool cityId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProvincesTableTableManager get provinces =>
      $$ProvincesTableTableManager(_db, _db.provinces);
  $$CitiesTableTableManager get cities =>
      $$CitiesTableTableManager(_db, _db.cities);
  $$JadwalTableTableManager get jadwal =>
      $$JadwalTableTableManager(_db, _db.jadwal);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
