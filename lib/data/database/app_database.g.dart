// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DriversTable extends Drivers with TableInfo<$DriversTable, Driver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriversTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, phone, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drivers';
  @override
  VerificationContext validateIntegrity(Insertable<Driver> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Driver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Driver(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $DriversTable createAlias(String alias) {
    return $DriversTable(attachedDatabase, alias);
  }
}

class Driver extends DataClass implements Insertable<Driver> {
  final int id;
  final String name;
  final String phone;
  final bool isActive;
  final DateTime createdAt;
  const Driver(
      {required this.id,
      required this.name,
      required this.phone,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DriversCompanion toCompanion(bool nullToAbsent) {
    return DriversCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Driver.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Driver(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Driver copyWith(
          {int? id,
          String? name,
          String? phone,
          bool? isActive,
          DateTime? createdAt}) =>
      Driver(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Driver copyWithCompanion(DriversCompanion data) {
    return Driver(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Driver(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Driver &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class DriversCompanion extends UpdateCompanion<Driver> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> phone;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const DriversCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DriversCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String phone,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        phone = Value(phone);
  static Insertable<Driver> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DriversCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? phone,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return DriversCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriversCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _plateNumberMeta =
      const VerificationMeta('plateNumber');
  @override
  late final GeneratedColumn<String> plateNumber = GeneratedColumn<String>(
      'plate_number', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _capacityMeta =
      const VerificationMeta('capacity');
  @override
  late final GeneratedColumn<int> capacity = GeneratedColumn<int>(
      'capacity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, brand, plateNumber, capacity, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicle> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('plate_number')) {
      context.handle(
          _plateNumberMeta,
          plateNumber.isAcceptableOrUnknown(
              data['plate_number']!, _plateNumberMeta));
    } else if (isInserting) {
      context.missing(_plateNumberMeta);
    }
    if (data.containsKey('capacity')) {
      context.handle(_capacityMeta,
          capacity.isAcceptableOrUnknown(data['capacity']!, _capacityMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand'])!,
      plateNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plate_number'])!,
      capacity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}capacity'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String brand;
  final String plateNumber;
  final int capacity;
  final bool isActive;
  final DateTime createdAt;
  const Vehicle(
      {required this.id,
      required this.brand,
      required this.plateNumber,
      required this.capacity,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['brand'] = Variable<String>(brand);
    map['plate_number'] = Variable<String>(plateNumber);
    map['capacity'] = Variable<int>(capacity);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      brand: Value(brand),
      plateNumber: Value(plateNumber),
      capacity: Value(capacity),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Vehicle.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      brand: serializer.fromJson<String>(json['brand']),
      plateNumber: serializer.fromJson<String>(json['plateNumber']),
      capacity: serializer.fromJson<int>(json['capacity']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'brand': serializer.toJson<String>(brand),
      'plateNumber': serializer.toJson<String>(plateNumber),
      'capacity': serializer.toJson<int>(capacity),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Vehicle copyWith(
          {int? id,
          String? brand,
          String? plateNumber,
          int? capacity,
          bool? isActive,
          DateTime? createdAt}) =>
      Vehicle(
        id: id ?? this.id,
        brand: brand ?? this.brand,
        plateNumber: plateNumber ?? this.plateNumber,
        capacity: capacity ?? this.capacity,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      brand: data.brand.present ? data.brand.value : this.brand,
      plateNumber:
          data.plateNumber.present ? data.plateNumber.value : this.plateNumber,
      capacity: data.capacity.present ? data.capacity.value : this.capacity,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('capacity: $capacity, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, brand, plateNumber, capacity, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.brand == this.brand &&
          other.plateNumber == this.plateNumber &&
          other.capacity == this.capacity &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> brand;
  final Value<String> plateNumber;
  final Value<int> capacity;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.brand = const Value.absent(),
    this.plateNumber = const Value.absent(),
    this.capacity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String brand,
    required String plateNumber,
    this.capacity = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : brand = Value(brand),
        plateNumber = Value(plateNumber);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? brand,
    Expression<String>? plateNumber,
    Expression<int>? capacity,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (brand != null) 'brand': brand,
      if (plateNumber != null) 'plate_number': plateNumber,
      if (capacity != null) 'capacity': capacity,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  VehiclesCompanion copyWith(
      {Value<int>? id,
      Value<String>? brand,
      Value<String>? plateNumber,
      Value<int>? capacity,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return VehiclesCompanion(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      plateNumber: plateNumber ?? this.plateNumber,
      capacity: capacity ?? this.capacity,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (plateNumber.present) {
      map['plate_number'] = Variable<String>(plateNumber.value);
    }
    if (capacity.present) {
      map['capacity'] = Variable<int>(capacity.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('brand: $brand, ')
          ..write('plateNumber: $plateNumber, ')
          ..write('capacity: $capacity, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PassengersTable extends Passengers
    with TableInfo<$PassengersTable, Passenger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassengersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _baseCityMeta =
      const VerificationMeta('baseCity');
  @override
  late final GeneratedColumn<String> baseCity = GeneratedColumn<String>(
      'base_city', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _baseLatMeta =
      const VerificationMeta('baseLat');
  @override
  late final GeneratedColumn<double> baseLat = GeneratedColumn<double>(
      'base_lat', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _baseLngMeta =
      const VerificationMeta('baseLng');
  @override
  late final GeneratedColumn<double> baseLng = GeneratedColumn<double>(
      'base_lng', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, role, phone, baseCity, baseLat, baseLng, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passengers';
  @override
  VerificationContext validateIntegrity(Insertable<Passenger> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('base_city')) {
      context.handle(_baseCityMeta,
          baseCity.isAcceptableOrUnknown(data['base_city']!, _baseCityMeta));
    } else if (isInserting) {
      context.missing(_baseCityMeta);
    }
    if (data.containsKey('base_lat')) {
      context.handle(_baseLatMeta,
          baseLat.isAcceptableOrUnknown(data['base_lat']!, _baseLatMeta));
    }
    if (data.containsKey('base_lng')) {
      context.handle(_baseLngMeta,
          baseLng.isAcceptableOrUnknown(data['base_lng']!, _baseLngMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Passenger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Passenger(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      baseCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_city'])!,
      baseLat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_lat']),
      baseLng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_lng']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PassengersTable createAlias(String alias) {
    return $PassengersTable(attachedDatabase, alias);
  }
}

class Passenger extends DataClass implements Insertable<Passenger> {
  final int id;
  final String name;
  final String role;
  final String phone;
  final String baseCity;
  final double? baseLat;
  final double? baseLng;
  final bool isActive;
  final DateTime createdAt;
  const Passenger(
      {required this.id,
      required this.name,
      required this.role,
      required this.phone,
      required this.baseCity,
      this.baseLat,
      this.baseLng,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['phone'] = Variable<String>(phone);
    map['base_city'] = Variable<String>(baseCity);
    if (!nullToAbsent || baseLat != null) {
      map['base_lat'] = Variable<double>(baseLat);
    }
    if (!nullToAbsent || baseLng != null) {
      map['base_lng'] = Variable<double>(baseLng);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PassengersCompanion toCompanion(bool nullToAbsent) {
    return PassengersCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      phone: Value(phone),
      baseCity: Value(baseCity),
      baseLat: baseLat == null && nullToAbsent
          ? const Value.absent()
          : Value(baseLat),
      baseLng: baseLng == null && nullToAbsent
          ? const Value.absent()
          : Value(baseLng),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Passenger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Passenger(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      phone: serializer.fromJson<String>(json['phone']),
      baseCity: serializer.fromJson<String>(json['baseCity']),
      baseLat: serializer.fromJson<double?>(json['baseLat']),
      baseLng: serializer.fromJson<double?>(json['baseLng']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'phone': serializer.toJson<String>(phone),
      'baseCity': serializer.toJson<String>(baseCity),
      'baseLat': serializer.toJson<double?>(baseLat),
      'baseLng': serializer.toJson<double?>(baseLng),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Passenger copyWith(
          {int? id,
          String? name,
          String? role,
          String? phone,
          String? baseCity,
          Value<double?> baseLat = const Value.absent(),
          Value<double?> baseLng = const Value.absent(),
          bool? isActive,
          DateTime? createdAt}) =>
      Passenger(
        id: id ?? this.id,
        name: name ?? this.name,
        role: role ?? this.role,
        phone: phone ?? this.phone,
        baseCity: baseCity ?? this.baseCity,
        baseLat: baseLat.present ? baseLat.value : this.baseLat,
        baseLng: baseLng.present ? baseLng.value : this.baseLng,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  Passenger copyWithCompanion(PassengersCompanion data) {
    return Passenger(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      phone: data.phone.present ? data.phone.value : this.phone,
      baseCity: data.baseCity.present ? data.baseCity.value : this.baseCity,
      baseLat: data.baseLat.present ? data.baseLat.value : this.baseLat,
      baseLng: data.baseLng.present ? data.baseLng.value : this.baseLng,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Passenger(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('baseCity: $baseCity, ')
          ..write('baseLat: $baseLat, ')
          ..write('baseLng: $baseLng, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, role, phone, baseCity, baseLat, baseLng, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Passenger &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.phone == this.phone &&
          other.baseCity == this.baseCity &&
          other.baseLat == this.baseLat &&
          other.baseLng == this.baseLng &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class PassengersCompanion extends UpdateCompanion<Passenger> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> phone;
  final Value<String> baseCity;
  final Value<double?> baseLat;
  final Value<double?> baseLng;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const PassengersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.phone = const Value.absent(),
    this.baseCity = const Value.absent(),
    this.baseLat = const Value.absent(),
    this.baseLng = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PassengersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String role,
    required String phone,
    required String baseCity,
    this.baseLat = const Value.absent(),
    this.baseLng = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : name = Value(name),
        role = Value(role),
        phone = Value(phone),
        baseCity = Value(baseCity);
  static Insertable<Passenger> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? phone,
    Expression<String>? baseCity,
    Expression<double>? baseLat,
    Expression<double>? baseLng,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (phone != null) 'phone': phone,
      if (baseCity != null) 'base_city': baseCity,
      if (baseLat != null) 'base_lat': baseLat,
      if (baseLng != null) 'base_lng': baseLng,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PassengersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? role,
      Value<String>? phone,
      Value<String>? baseCity,
      Value<double?>? baseLat,
      Value<double?>? baseLng,
      Value<bool>? isActive,
      Value<DateTime>? createdAt}) {
    return PassengersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      baseCity: baseCity ?? this.baseCity,
      baseLat: baseLat ?? this.baseLat,
      baseLng: baseLng ?? this.baseLng,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (baseCity.present) {
      map['base_city'] = Variable<String>(baseCity.value);
    }
    if (baseLat.present) {
      map['base_lat'] = Variable<double>(baseLat.value);
    }
    if (baseLng.present) {
      map['base_lng'] = Variable<double>(baseLng.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassengersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('phone: $phone, ')
          ..write('baseCity: $baseCity, ')
          ..write('baseLat: $baseLat, ')
          ..write('baseLng: $baseLng, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $KnownLocationsTable extends KnownLocations
    with TableInfo<$KnownLocationsTable, KnownLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KnownLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 150),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _shortCodeMeta =
      const VerificationMeta('shortCode');
  @override
  late final GeneratedColumn<String> shortCode = GeneratedColumn<String>(
      'short_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 2, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isAirportMeta =
      const VerificationMeta('isAirport');
  @override
  late final GeneratedColumn<bool> isAirport = GeneratedColumn<bool>(
      'is_airport', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_airport" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, shortCode, city, latitude, longitude, isAirport, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'known_locations';
  @override
  VerificationContext validateIntegrity(Insertable<KnownLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('short_code')) {
      context.handle(_shortCodeMeta,
          shortCode.isAcceptableOrUnknown(data['short_code']!, _shortCodeMeta));
    } else if (isInserting) {
      context.missing(_shortCodeMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('is_airport')) {
      context.handle(_isAirportMeta,
          isAirport.isAcceptableOrUnknown(data['is_airport']!, _isAirportMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KnownLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KnownLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      shortCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}short_code'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      isAirport: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_airport'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $KnownLocationsTable createAlias(String alias) {
    return $KnownLocationsTable(attachedDatabase, alias);
  }
}

class KnownLocation extends DataClass implements Insertable<KnownLocation> {
  final int id;
  final String name;
  final String shortCode;
  final String city;
  final double latitude;
  final double longitude;
  final bool isAirport;
  final bool isActive;
  const KnownLocation(
      {required this.id,
      required this.name,
      required this.shortCode,
      required this.city,
      required this.latitude,
      required this.longitude,
      required this.isAirport,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['short_code'] = Variable<String>(shortCode);
    map['city'] = Variable<String>(city);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['is_airport'] = Variable<bool>(isAirport);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  KnownLocationsCompanion toCompanion(bool nullToAbsent) {
    return KnownLocationsCompanion(
      id: Value(id),
      name: Value(name),
      shortCode: Value(shortCode),
      city: Value(city),
      latitude: Value(latitude),
      longitude: Value(longitude),
      isAirport: Value(isAirport),
      isActive: Value(isActive),
    );
  }

  factory KnownLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KnownLocation(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      shortCode: serializer.fromJson<String>(json['shortCode']),
      city: serializer.fromJson<String>(json['city']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      isAirport: serializer.fromJson<bool>(json['isAirport']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'shortCode': serializer.toJson<String>(shortCode),
      'city': serializer.toJson<String>(city),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'isAirport': serializer.toJson<bool>(isAirport),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  KnownLocation copyWith(
          {int? id,
          String? name,
          String? shortCode,
          String? city,
          double? latitude,
          double? longitude,
          bool? isAirport,
          bool? isActive}) =>
      KnownLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        shortCode: shortCode ?? this.shortCode,
        city: city ?? this.city,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isAirport: isAirport ?? this.isAirport,
        isActive: isActive ?? this.isActive,
      );
  KnownLocation copyWithCompanion(KnownLocationsCompanion data) {
    return KnownLocation(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      shortCode: data.shortCode.present ? data.shortCode.value : this.shortCode,
      city: data.city.present ? data.city.value : this.city,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      isAirport: data.isAirport.present ? data.isAirport.value : this.isAirport,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KnownLocation(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortCode: $shortCode, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isAirport: $isAirport, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, shortCode, city, latitude, longitude, isAirport, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KnownLocation &&
          other.id == this.id &&
          other.name == this.name &&
          other.shortCode == this.shortCode &&
          other.city == this.city &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.isAirport == this.isAirport &&
          other.isActive == this.isActive);
}

class KnownLocationsCompanion extends UpdateCompanion<KnownLocation> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> shortCode;
  final Value<String> city;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<bool> isAirport;
  final Value<bool> isActive;
  const KnownLocationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.shortCode = const Value.absent(),
    this.city = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.isAirport = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  KnownLocationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String shortCode,
    required String city,
    required double latitude,
    required double longitude,
    this.isAirport = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        shortCode = Value(shortCode),
        city = Value(city),
        latitude = Value(latitude),
        longitude = Value(longitude);
  static Insertable<KnownLocation> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? shortCode,
    Expression<String>? city,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<bool>? isAirport,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (shortCode != null) 'short_code': shortCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (isAirport != null) 'is_airport': isAirport,
      if (isActive != null) 'is_active': isActive,
    });
  }

  KnownLocationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? shortCode,
      Value<String>? city,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<bool>? isAirport,
      Value<bool>? isActive}) {
    return KnownLocationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      shortCode: shortCode ?? this.shortCode,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAirport: isAirport ?? this.isAirport,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (shortCode.present) {
      map['short_code'] = Variable<String>(shortCode.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (isAirport.present) {
      map['is_airport'] = Variable<bool>(isAirport.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KnownLocationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('shortCode: $shortCode, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('isAirport: $isAirport, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $MissionsTable extends Missions with TableInfo<$MissionsTable, Mission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _driverIdMeta =
      const VerificationMeta('driverId');
  @override
  late final GeneratedColumn<int> driverId = GeneratedColumn<int>(
      'driver_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES drivers (id)'));
  static const VerificationMeta _vehicleIdMeta =
      const VerificationMeta('vehicleId');
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
      'vehicle_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vehicles (id)'));
  static const VerificationMeta _destinationIdMeta =
      const VerificationMeta('destinationId');
  @override
  late final GeneratedColumn<int> destinationId = GeneratedColumn<int>(
      'destination_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES known_locations (id)'));
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('PLANIFIEE'));
  static const VerificationMeta _totalDistanceKmMeta =
      const VerificationMeta('totalDistanceKm');
  @override
  late final GeneratedColumn<double> totalDistanceKm = GeneratedColumn<double>(
      'total_distance_km', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _estimatedDurationMinMeta =
      const VerificationMeta('estimatedDurationMin');
  @override
  late final GeneratedColumn<int> estimatedDurationMin = GeneratedColumn<int>(
      'estimated_duration_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _googleMapsUrlMeta =
      const VerificationMeta('googleMapsUrl');
  @override
  late final GeneratedColumn<String> googleMapsUrl = GeneratedColumn<String>(
      'google_maps_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _returnToBaseMeta =
      const VerificationMeta('returnToBase');
  @override
  late final GeneratedColumn<bool> returnToBase = GeneratedColumn<bool>(
      'return_to_base', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("return_to_base" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reference,
        type,
        driverId,
        vehicleId,
        destinationId,
        scheduledAt,
        status,
        totalDistanceKm,
        estimatedDurationMin,
        googleMapsUrl,
        returnToBase,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'missions';
  @override
  VerificationContext validateIntegrity(Insertable<Mission> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('driver_id')) {
      context.handle(_driverIdMeta,
          driverId.isAcceptableOrUnknown(data['driver_id']!, _driverIdMeta));
    } else if (isInserting) {
      context.missing(_driverIdMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(_vehicleIdMeta,
          vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta));
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('destination_id')) {
      context.handle(
          _destinationIdMeta,
          destinationId.isAcceptableOrUnknown(
              data['destination_id']!, _destinationIdMeta));
    } else if (isInserting) {
      context.missing(_destinationIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('total_distance_km')) {
      context.handle(
          _totalDistanceKmMeta,
          totalDistanceKm.isAcceptableOrUnknown(
              data['total_distance_km']!, _totalDistanceKmMeta));
    }
    if (data.containsKey('estimated_duration_min')) {
      context.handle(
          _estimatedDurationMinMeta,
          estimatedDurationMin.isAcceptableOrUnknown(
              data['estimated_duration_min']!, _estimatedDurationMinMeta));
    }
    if (data.containsKey('google_maps_url')) {
      context.handle(
          _googleMapsUrlMeta,
          googleMapsUrl.isAcceptableOrUnknown(
              data['google_maps_url']!, _googleMapsUrlMeta));
    }
    if (data.containsKey('return_to_base')) {
      context.handle(
          _returnToBaseMeta,
          returnToBase.isAcceptableOrUnknown(
              data['return_to_base']!, _returnToBaseMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mission(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      driverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}driver_id'])!,
      vehicleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vehicle_id'])!,
      destinationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}destination_id'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}scheduled_at'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalDistanceKm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_distance_km']),
      estimatedDurationMin: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}estimated_duration_min']),
      googleMapsUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}google_maps_url']),
      returnToBase: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}return_to_base'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MissionsTable createAlias(String alias) {
    return $MissionsTable(attachedDatabase, alias);
  }
}

class Mission extends DataClass implements Insertable<Mission> {
  final int id;
  final String reference;
  final String type;
  final int driverId;
  final int vehicleId;
  final int destinationId;
  final DateTime scheduledAt;
  final String status;
  final double? totalDistanceKm;
  final int? estimatedDurationMin;
  final String? googleMapsUrl;
  final bool returnToBase;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Mission(
      {required this.id,
      required this.reference,
      required this.type,
      required this.driverId,
      required this.vehicleId,
      required this.destinationId,
      required this.scheduledAt,
      required this.status,
      this.totalDistanceKm,
      this.estimatedDurationMin,
      this.googleMapsUrl,
      required this.returnToBase,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['type'] = Variable<String>(type);
    map['driver_id'] = Variable<int>(driverId);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['destination_id'] = Variable<int>(destinationId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || totalDistanceKm != null) {
      map['total_distance_km'] = Variable<double>(totalDistanceKm);
    }
    if (!nullToAbsent || estimatedDurationMin != null) {
      map['estimated_duration_min'] = Variable<int>(estimatedDurationMin);
    }
    if (!nullToAbsent || googleMapsUrl != null) {
      map['google_maps_url'] = Variable<String>(googleMapsUrl);
    }
    map['return_to_base'] = Variable<bool>(returnToBase);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MissionsCompanion toCompanion(bool nullToAbsent) {
    return MissionsCompanion(
      id: Value(id),
      reference: Value(reference),
      type: Value(type),
      driverId: Value(driverId),
      vehicleId: Value(vehicleId),
      destinationId: Value(destinationId),
      scheduledAt: Value(scheduledAt),
      status: Value(status),
      totalDistanceKm: totalDistanceKm == null && nullToAbsent
          ? const Value.absent()
          : Value(totalDistanceKm),
      estimatedDurationMin: estimatedDurationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedDurationMin),
      googleMapsUrl: googleMapsUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(googleMapsUrl),
      returnToBase: Value(returnToBase),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Mission.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mission(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      type: serializer.fromJson<String>(json['type']),
      driverId: serializer.fromJson<int>(json['driverId']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      destinationId: serializer.fromJson<int>(json['destinationId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      status: serializer.fromJson<String>(json['status']),
      totalDistanceKm: serializer.fromJson<double?>(json['totalDistanceKm']),
      estimatedDurationMin:
          serializer.fromJson<int?>(json['estimatedDurationMin']),
      googleMapsUrl: serializer.fromJson<String?>(json['googleMapsUrl']),
      returnToBase: serializer.fromJson<bool>(json['returnToBase']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'type': serializer.toJson<String>(type),
      'driverId': serializer.toJson<int>(driverId),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'destinationId': serializer.toJson<int>(destinationId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'status': serializer.toJson<String>(status),
      'totalDistanceKm': serializer.toJson<double?>(totalDistanceKm),
      'estimatedDurationMin': serializer.toJson<int?>(estimatedDurationMin),
      'googleMapsUrl': serializer.toJson<String?>(googleMapsUrl),
      'returnToBase': serializer.toJson<bool>(returnToBase),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Mission copyWith(
          {int? id,
          String? reference,
          String? type,
          int? driverId,
          int? vehicleId,
          int? destinationId,
          DateTime? scheduledAt,
          String? status,
          Value<double?> totalDistanceKm = const Value.absent(),
          Value<int?> estimatedDurationMin = const Value.absent(),
          Value<String?> googleMapsUrl = const Value.absent(),
          bool? returnToBase,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Mission(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        type: type ?? this.type,
        driverId: driverId ?? this.driverId,
        vehicleId: vehicleId ?? this.vehicleId,
        destinationId: destinationId ?? this.destinationId,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        status: status ?? this.status,
        totalDistanceKm: totalDistanceKm.present
            ? totalDistanceKm.value
            : this.totalDistanceKm,
        estimatedDurationMin: estimatedDurationMin.present
            ? estimatedDurationMin.value
            : this.estimatedDurationMin,
        googleMapsUrl:
            googleMapsUrl.present ? googleMapsUrl.value : this.googleMapsUrl,
        returnToBase: returnToBase ?? this.returnToBase,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Mission copyWithCompanion(MissionsCompanion data) {
    return Mission(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      type: data.type.present ? data.type.value : this.type,
      driverId: data.driverId.present ? data.driverId.value : this.driverId,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      destinationId: data.destinationId.present
          ? data.destinationId.value
          : this.destinationId,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      status: data.status.present ? data.status.value : this.status,
      totalDistanceKm: data.totalDistanceKm.present
          ? data.totalDistanceKm.value
          : this.totalDistanceKm,
      estimatedDurationMin: data.estimatedDurationMin.present
          ? data.estimatedDurationMin.value
          : this.estimatedDurationMin,
      googleMapsUrl: data.googleMapsUrl.present
          ? data.googleMapsUrl.value
          : this.googleMapsUrl,
      returnToBase: data.returnToBase.present
          ? data.returnToBase.value
          : this.returnToBase,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mission(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('type: $type, ')
          ..write('driverId: $driverId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('destinationId: $destinationId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('estimatedDurationMin: $estimatedDurationMin, ')
          ..write('googleMapsUrl: $googleMapsUrl, ')
          ..write('returnToBase: $returnToBase, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      reference,
      type,
      driverId,
      vehicleId,
      destinationId,
      scheduledAt,
      status,
      totalDistanceKm,
      estimatedDurationMin,
      googleMapsUrl,
      returnToBase,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mission &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.type == this.type &&
          other.driverId == this.driverId &&
          other.vehicleId == this.vehicleId &&
          other.destinationId == this.destinationId &&
          other.scheduledAt == this.scheduledAt &&
          other.status == this.status &&
          other.totalDistanceKm == this.totalDistanceKm &&
          other.estimatedDurationMin == this.estimatedDurationMin &&
          other.googleMapsUrl == this.googleMapsUrl &&
          other.returnToBase == this.returnToBase &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MissionsCompanion extends UpdateCompanion<Mission> {
  final Value<int> id;
  final Value<String> reference;
  final Value<String> type;
  final Value<int> driverId;
  final Value<int> vehicleId;
  final Value<int> destinationId;
  final Value<DateTime> scheduledAt;
  final Value<String> status;
  final Value<double?> totalDistanceKm;
  final Value<int?> estimatedDurationMin;
  final Value<String?> googleMapsUrl;
  final Value<bool> returnToBase;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const MissionsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.type = const Value.absent(),
    this.driverId = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.destinationId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.status = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.estimatedDurationMin = const Value.absent(),
    this.googleMapsUrl = const Value.absent(),
    this.returnToBase = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MissionsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required String type,
    required int driverId,
    required int vehicleId,
    required int destinationId,
    required DateTime scheduledAt,
    this.status = const Value.absent(),
    this.totalDistanceKm = const Value.absent(),
    this.estimatedDurationMin = const Value.absent(),
    this.googleMapsUrl = const Value.absent(),
    this.returnToBase = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : reference = Value(reference),
        type = Value(type),
        driverId = Value(driverId),
        vehicleId = Value(vehicleId),
        destinationId = Value(destinationId),
        scheduledAt = Value(scheduledAt);
  static Insertable<Mission> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<String>? type,
    Expression<int>? driverId,
    Expression<int>? vehicleId,
    Expression<int>? destinationId,
    Expression<DateTime>? scheduledAt,
    Expression<String>? status,
    Expression<double>? totalDistanceKm,
    Expression<int>? estimatedDurationMin,
    Expression<String>? googleMapsUrl,
    Expression<bool>? returnToBase,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (type != null) 'type': type,
      if (driverId != null) 'driver_id': driverId,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (destinationId != null) 'destination_id': destinationId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (status != null) 'status': status,
      if (totalDistanceKm != null) 'total_distance_km': totalDistanceKm,
      if (estimatedDurationMin != null)
        'estimated_duration_min': estimatedDurationMin,
      if (googleMapsUrl != null) 'google_maps_url': googleMapsUrl,
      if (returnToBase != null) 'return_to_base': returnToBase,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MissionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? reference,
      Value<String>? type,
      Value<int>? driverId,
      Value<int>? vehicleId,
      Value<int>? destinationId,
      Value<DateTime>? scheduledAt,
      Value<String>? status,
      Value<double?>? totalDistanceKm,
      Value<int?>? estimatedDurationMin,
      Value<String?>? googleMapsUrl,
      Value<bool>? returnToBase,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return MissionsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      type: type ?? this.type,
      driverId: driverId ?? this.driverId,
      vehicleId: vehicleId ?? this.vehicleId,
      destinationId: destinationId ?? this.destinationId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      estimatedDurationMin: estimatedDurationMin ?? this.estimatedDurationMin,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      returnToBase: returnToBase ?? this.returnToBase,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (driverId.present) {
      map['driver_id'] = Variable<int>(driverId.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (destinationId.present) {
      map['destination_id'] = Variable<int>(destinationId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalDistanceKm.present) {
      map['total_distance_km'] = Variable<double>(totalDistanceKm.value);
    }
    if (estimatedDurationMin.present) {
      map['estimated_duration_min'] = Variable<int>(estimatedDurationMin.value);
    }
    if (googleMapsUrl.present) {
      map['google_maps_url'] = Variable<String>(googleMapsUrl.value);
    }
    if (returnToBase.present) {
      map['return_to_base'] = Variable<bool>(returnToBase.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('type: $type, ')
          ..write('driverId: $driverId, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('destinationId: $destinationId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('status: $status, ')
          ..write('totalDistanceKm: $totalDistanceKm, ')
          ..write('estimatedDurationMin: $estimatedDurationMin, ')
          ..write('googleMapsUrl: $googleMapsUrl, ')
          ..write('returnToBase: $returnToBase, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MissionPassengersTable extends MissionPassengers
    with TableInfo<$MissionPassengersTable, MissionPassenger> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionPassengersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _missionIdMeta =
      const VerificationMeta('missionId');
  @override
  late final GeneratedColumn<int> missionId = GeneratedColumn<int>(
      'mission_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES missions (id)'));
  static const VerificationMeta _passengerIdMeta =
      const VerificationMeta('passengerId');
  @override
  late final GeneratedColumn<int> passengerId = GeneratedColumn<int>(
      'passenger_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES passengers (id)'));
  static const VerificationMeta _guestNameMeta =
      const VerificationMeta('guestName');
  @override
  late final GeneratedColumn<String> guestName = GeneratedColumn<String>(
      'guest_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guestPhoneMeta =
      const VerificationMeta('guestPhone');
  @override
  late final GeneratedColumn<String> guestPhone = GeneratedColumn<String>(
      'guest_phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pickupLocationIdMeta =
      const VerificationMeta('pickupLocationId');
  @override
  late final GeneratedColumn<int> pickupLocationId = GeneratedColumn<int>(
      'pickup_location_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES known_locations (id)'));
  static const VerificationMeta _pickupCityMeta =
      const VerificationMeta('pickupCity');
  @override
  late final GeneratedColumn<String> pickupCity = GeneratedColumn<String>(
      'pickup_city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pickupOrderMeta =
      const VerificationMeta('pickupOrder');
  @override
  late final GeneratedColumn<int> pickupOrder = GeneratedColumn<int>(
      'pickup_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _whatsappStatusMeta =
      const VerificationMeta('whatsappStatus');
  @override
  late final GeneratedColumn<String> whatsappStatus = GeneratedColumn<String>(
      'whatsapp_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NON_ENVOYE'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        missionId,
        passengerId,
        guestName,
        guestPhone,
        pickupLocationId,
        pickupCity,
        pickupOrder,
        whatsappStatus
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_passengers';
  @override
  VerificationContext validateIntegrity(Insertable<MissionPassenger> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mission_id')) {
      context.handle(_missionIdMeta,
          missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta));
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('passenger_id')) {
      context.handle(
          _passengerIdMeta,
          passengerId.isAcceptableOrUnknown(
              data['passenger_id']!, _passengerIdMeta));
    }
    if (data.containsKey('guest_name')) {
      context.handle(_guestNameMeta,
          guestName.isAcceptableOrUnknown(data['guest_name']!, _guestNameMeta));
    }
    if (data.containsKey('guest_phone')) {
      context.handle(
          _guestPhoneMeta,
          guestPhone.isAcceptableOrUnknown(
              data['guest_phone']!, _guestPhoneMeta));
    }
    if (data.containsKey('pickup_location_id')) {
      context.handle(
          _pickupLocationIdMeta,
          pickupLocationId.isAcceptableOrUnknown(
              data['pickup_location_id']!, _pickupLocationIdMeta));
    }
    if (data.containsKey('pickup_city')) {
      context.handle(
          _pickupCityMeta,
          pickupCity.isAcceptableOrUnknown(
              data['pickup_city']!, _pickupCityMeta));
    }
    if (data.containsKey('pickup_order')) {
      context.handle(
          _pickupOrderMeta,
          pickupOrder.isAcceptableOrUnknown(
              data['pickup_order']!, _pickupOrderMeta));
    }
    if (data.containsKey('whatsapp_status')) {
      context.handle(
          _whatsappStatusMeta,
          whatsappStatus.isAcceptableOrUnknown(
              data['whatsapp_status']!, _whatsappStatusMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MissionPassenger map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionPassenger(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      missionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mission_id'])!,
      passengerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}passenger_id']),
      guestName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_name']),
      guestPhone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_phone']),
      pickupLocationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pickup_location_id']),
      pickupCity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pickup_city']),
      pickupOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pickup_order'])!,
      whatsappStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}whatsapp_status'])!,
    );
  }

  @override
  $MissionPassengersTable createAlias(String alias) {
    return $MissionPassengersTable(attachedDatabase, alias);
  }
}

class MissionPassenger extends DataClass
    implements Insertable<MissionPassenger> {
  final int id;
  final int missionId;
  final int? passengerId;
  final String? guestName;
  final String? guestPhone;
  final int? pickupLocationId;
  final String? pickupCity;
  final int pickupOrder;
  final String whatsappStatus;
  const MissionPassenger(
      {required this.id,
      required this.missionId,
      this.passengerId,
      this.guestName,
      this.guestPhone,
      this.pickupLocationId,
      this.pickupCity,
      required this.pickupOrder,
      required this.whatsappStatus});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mission_id'] = Variable<int>(missionId);
    if (!nullToAbsent || passengerId != null) {
      map['passenger_id'] = Variable<int>(passengerId);
    }
    if (!nullToAbsent || guestName != null) {
      map['guest_name'] = Variable<String>(guestName);
    }
    if (!nullToAbsent || guestPhone != null) {
      map['guest_phone'] = Variable<String>(guestPhone);
    }
    if (!nullToAbsent || pickupLocationId != null) {
      map['pickup_location_id'] = Variable<int>(pickupLocationId);
    }
    if (!nullToAbsent || pickupCity != null) {
      map['pickup_city'] = Variable<String>(pickupCity);
    }
    map['pickup_order'] = Variable<int>(pickupOrder);
    map['whatsapp_status'] = Variable<String>(whatsappStatus);
    return map;
  }

  MissionPassengersCompanion toCompanion(bool nullToAbsent) {
    return MissionPassengersCompanion(
      id: Value(id),
      missionId: Value(missionId),
      passengerId: passengerId == null && nullToAbsent
          ? const Value.absent()
          : Value(passengerId),
      guestName: guestName == null && nullToAbsent
          ? const Value.absent()
          : Value(guestName),
      guestPhone: guestPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(guestPhone),
      pickupLocationId: pickupLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(pickupLocationId),
      pickupCity: pickupCity == null && nullToAbsent
          ? const Value.absent()
          : Value(pickupCity),
      pickupOrder: Value(pickupOrder),
      whatsappStatus: Value(whatsappStatus),
    );
  }

  factory MissionPassenger.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionPassenger(
      id: serializer.fromJson<int>(json['id']),
      missionId: serializer.fromJson<int>(json['missionId']),
      passengerId: serializer.fromJson<int?>(json['passengerId']),
      guestName: serializer.fromJson<String?>(json['guestName']),
      guestPhone: serializer.fromJson<String?>(json['guestPhone']),
      pickupLocationId: serializer.fromJson<int?>(json['pickupLocationId']),
      pickupCity: serializer.fromJson<String?>(json['pickupCity']),
      pickupOrder: serializer.fromJson<int>(json['pickupOrder']),
      whatsappStatus: serializer.fromJson<String>(json['whatsappStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'missionId': serializer.toJson<int>(missionId),
      'passengerId': serializer.toJson<int?>(passengerId),
      'guestName': serializer.toJson<String?>(guestName),
      'guestPhone': serializer.toJson<String?>(guestPhone),
      'pickupLocationId': serializer.toJson<int?>(pickupLocationId),
      'pickupCity': serializer.toJson<String?>(pickupCity),
      'pickupOrder': serializer.toJson<int>(pickupOrder),
      'whatsappStatus': serializer.toJson<String>(whatsappStatus),
    };
  }

  MissionPassenger copyWith(
          {int? id,
          int? missionId,
          Value<int?> passengerId = const Value.absent(),
          Value<String?> guestName = const Value.absent(),
          Value<String?> guestPhone = const Value.absent(),
          Value<int?> pickupLocationId = const Value.absent(),
          Value<String?> pickupCity = const Value.absent(),
          int? pickupOrder,
          String? whatsappStatus}) =>
      MissionPassenger(
        id: id ?? this.id,
        missionId: missionId ?? this.missionId,
        passengerId: passengerId.present ? passengerId.value : this.passengerId,
        guestName: guestName.present ? guestName.value : this.guestName,
        guestPhone: guestPhone.present ? guestPhone.value : this.guestPhone,
        pickupLocationId: pickupLocationId.present
            ? pickupLocationId.value
            : this.pickupLocationId,
        pickupCity: pickupCity.present ? pickupCity.value : this.pickupCity,
        pickupOrder: pickupOrder ?? this.pickupOrder,
        whatsappStatus: whatsappStatus ?? this.whatsappStatus,
      );
  MissionPassenger copyWithCompanion(MissionPassengersCompanion data) {
    return MissionPassenger(
      id: data.id.present ? data.id.value : this.id,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      passengerId:
          data.passengerId.present ? data.passengerId.value : this.passengerId,
      guestName: data.guestName.present ? data.guestName.value : this.guestName,
      guestPhone:
          data.guestPhone.present ? data.guestPhone.value : this.guestPhone,
      pickupLocationId: data.pickupLocationId.present
          ? data.pickupLocationId.value
          : this.pickupLocationId,
      pickupCity:
          data.pickupCity.present ? data.pickupCity.value : this.pickupCity,
      pickupOrder:
          data.pickupOrder.present ? data.pickupOrder.value : this.pickupOrder,
      whatsappStatus: data.whatsappStatus.present
          ? data.whatsappStatus.value
          : this.whatsappStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionPassenger(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('passengerId: $passengerId, ')
          ..write('guestName: $guestName, ')
          ..write('guestPhone: $guestPhone, ')
          ..write('pickupLocationId: $pickupLocationId, ')
          ..write('pickupCity: $pickupCity, ')
          ..write('pickupOrder: $pickupOrder, ')
          ..write('whatsappStatus: $whatsappStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, missionId, passengerId, guestName,
      guestPhone, pickupLocationId, pickupCity, pickupOrder, whatsappStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionPassenger &&
          other.id == this.id &&
          other.missionId == this.missionId &&
          other.passengerId == this.passengerId &&
          other.guestName == this.guestName &&
          other.guestPhone == this.guestPhone &&
          other.pickupLocationId == this.pickupLocationId &&
          other.pickupCity == this.pickupCity &&
          other.pickupOrder == this.pickupOrder &&
          other.whatsappStatus == this.whatsappStatus);
}

class MissionPassengersCompanion extends UpdateCompanion<MissionPassenger> {
  final Value<int> id;
  final Value<int> missionId;
  final Value<int?> passengerId;
  final Value<String?> guestName;
  final Value<String?> guestPhone;
  final Value<int?> pickupLocationId;
  final Value<String?> pickupCity;
  final Value<int> pickupOrder;
  final Value<String> whatsappStatus;
  const MissionPassengersCompanion({
    this.id = const Value.absent(),
    this.missionId = const Value.absent(),
    this.passengerId = const Value.absent(),
    this.guestName = const Value.absent(),
    this.guestPhone = const Value.absent(),
    this.pickupLocationId = const Value.absent(),
    this.pickupCity = const Value.absent(),
    this.pickupOrder = const Value.absent(),
    this.whatsappStatus = const Value.absent(),
  });
  MissionPassengersCompanion.insert({
    this.id = const Value.absent(),
    required int missionId,
    this.passengerId = const Value.absent(),
    this.guestName = const Value.absent(),
    this.guestPhone = const Value.absent(),
    this.pickupLocationId = const Value.absent(),
    this.pickupCity = const Value.absent(),
    this.pickupOrder = const Value.absent(),
    this.whatsappStatus = const Value.absent(),
  }) : missionId = Value(missionId);
  static Insertable<MissionPassenger> custom({
    Expression<int>? id,
    Expression<int>? missionId,
    Expression<int>? passengerId,
    Expression<String>? guestName,
    Expression<String>? guestPhone,
    Expression<int>? pickupLocationId,
    Expression<String>? pickupCity,
    Expression<int>? pickupOrder,
    Expression<String>? whatsappStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (missionId != null) 'mission_id': missionId,
      if (passengerId != null) 'passenger_id': passengerId,
      if (guestName != null) 'guest_name': guestName,
      if (guestPhone != null) 'guest_phone': guestPhone,
      if (pickupLocationId != null) 'pickup_location_id': pickupLocationId,
      if (pickupCity != null) 'pickup_city': pickupCity,
      if (pickupOrder != null) 'pickup_order': pickupOrder,
      if (whatsappStatus != null) 'whatsapp_status': whatsappStatus,
    });
  }

  MissionPassengersCompanion copyWith(
      {Value<int>? id,
      Value<int>? missionId,
      Value<int?>? passengerId,
      Value<String?>? guestName,
      Value<String?>? guestPhone,
      Value<int?>? pickupLocationId,
      Value<String?>? pickupCity,
      Value<int>? pickupOrder,
      Value<String>? whatsappStatus}) {
    return MissionPassengersCompanion(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      passengerId: passengerId ?? this.passengerId,
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      pickupLocationId: pickupLocationId ?? this.pickupLocationId,
      pickupCity: pickupCity ?? this.pickupCity,
      pickupOrder: pickupOrder ?? this.pickupOrder,
      whatsappStatus: whatsappStatus ?? this.whatsappStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<int>(missionId.value);
    }
    if (passengerId.present) {
      map['passenger_id'] = Variable<int>(passengerId.value);
    }
    if (guestName.present) {
      map['guest_name'] = Variable<String>(guestName.value);
    }
    if (guestPhone.present) {
      map['guest_phone'] = Variable<String>(guestPhone.value);
    }
    if (pickupLocationId.present) {
      map['pickup_location_id'] = Variable<int>(pickupLocationId.value);
    }
    if (pickupCity.present) {
      map['pickup_city'] = Variable<String>(pickupCity.value);
    }
    if (pickupOrder.present) {
      map['pickup_order'] = Variable<int>(pickupOrder.value);
    }
    if (whatsappStatus.present) {
      map['whatsapp_status'] = Variable<String>(whatsappStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionPassengersCompanion(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('passengerId: $passengerId, ')
          ..write('guestName: $guestName, ')
          ..write('guestPhone: $guestPhone, ')
          ..write('pickupLocationId: $pickupLocationId, ')
          ..write('pickupCity: $pickupCity, ')
          ..write('pickupOrder: $pickupOrder, ')
          ..write('whatsappStatus: $whatsappStatus')
          ..write(')'))
        .toString();
  }
}

class $MissionStepsTable extends MissionSteps
    with TableInfo<$MissionStepsTable, MissionStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MissionStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _missionIdMeta =
      const VerificationMeta('missionId');
  @override
  late final GeneratedColumn<int> missionId = GeneratedColumn<int>(
      'mission_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES missions (id)'));
  static const VerificationMeta _stepOrderMeta =
      const VerificationMeta('stepOrder');
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
      'step_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _distanceFromPrevKmMeta =
      const VerificationMeta('distanceFromPrevKm');
  @override
  late final GeneratedColumn<double> distanceFromPrevKm =
      GeneratedColumn<double>('distance_from_prev_km', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _durationFromPrevMinMeta =
      const VerificationMeta('durationFromPrevMin');
  @override
  late final GeneratedColumn<int> durationFromPrevMin = GeneratedColumn<int>(
      'duration_from_prev_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        missionId,
        stepOrder,
        type,
        locationName,
        city,
        latitude,
        longitude,
        distanceFromPrevKm,
        durationFromPrevMin
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mission_steps';
  @override
  VerificationContext validateIntegrity(Insertable<MissionStep> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mission_id')) {
      context.handle(_missionIdMeta,
          missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta));
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(_stepOrderMeta,
          stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta));
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    } else if (isInserting) {
      context.missing(_locationNameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('distance_from_prev_km')) {
      context.handle(
          _distanceFromPrevKmMeta,
          distanceFromPrevKm.isAcceptableOrUnknown(
              data['distance_from_prev_km']!, _distanceFromPrevKmMeta));
    }
    if (data.containsKey('duration_from_prev_min')) {
      context.handle(
          _durationFromPrevMinMeta,
          durationFromPrevMin.isAcceptableOrUnknown(
              data['duration_from_prev_min']!, _durationFromPrevMinMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MissionStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MissionStep(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      missionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mission_id'])!,
      stepOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_order'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name'])!,
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      distanceFromPrevKm: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}distance_from_prev_km']),
      durationFromPrevMin: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}duration_from_prev_min']),
    );
  }

  @override
  $MissionStepsTable createAlias(String alias) {
    return $MissionStepsTable(attachedDatabase, alias);
  }
}

class MissionStep extends DataClass implements Insertable<MissionStep> {
  final int id;
  final int missionId;
  final int stepOrder;
  final String type;
  final String locationName;
  final String city;
  final double? latitude;
  final double? longitude;
  final double? distanceFromPrevKm;
  final int? durationFromPrevMin;
  const MissionStep(
      {required this.id,
      required this.missionId,
      required this.stepOrder,
      required this.type,
      required this.locationName,
      required this.city,
      this.latitude,
      this.longitude,
      this.distanceFromPrevKm,
      this.durationFromPrevMin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mission_id'] = Variable<int>(missionId);
    map['step_order'] = Variable<int>(stepOrder);
    map['type'] = Variable<String>(type);
    map['location_name'] = Variable<String>(locationName);
    map['city'] = Variable<String>(city);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || distanceFromPrevKm != null) {
      map['distance_from_prev_km'] = Variable<double>(distanceFromPrevKm);
    }
    if (!nullToAbsent || durationFromPrevMin != null) {
      map['duration_from_prev_min'] = Variable<int>(durationFromPrevMin);
    }
    return map;
  }

  MissionStepsCompanion toCompanion(bool nullToAbsent) {
    return MissionStepsCompanion(
      id: Value(id),
      missionId: Value(missionId),
      stepOrder: Value(stepOrder),
      type: Value(type),
      locationName: Value(locationName),
      city: Value(city),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      distanceFromPrevKm: distanceFromPrevKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceFromPrevKm),
      durationFromPrevMin: durationFromPrevMin == null && nullToAbsent
          ? const Value.absent()
          : Value(durationFromPrevMin),
    );
  }

  factory MissionStep.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MissionStep(
      id: serializer.fromJson<int>(json['id']),
      missionId: serializer.fromJson<int>(json['missionId']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
      type: serializer.fromJson<String>(json['type']),
      locationName: serializer.fromJson<String>(json['locationName']),
      city: serializer.fromJson<String>(json['city']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      distanceFromPrevKm:
          serializer.fromJson<double?>(json['distanceFromPrevKm']),
      durationFromPrevMin:
          serializer.fromJson<int?>(json['durationFromPrevMin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'missionId': serializer.toJson<int>(missionId),
      'stepOrder': serializer.toJson<int>(stepOrder),
      'type': serializer.toJson<String>(type),
      'locationName': serializer.toJson<String>(locationName),
      'city': serializer.toJson<String>(city),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'distanceFromPrevKm': serializer.toJson<double?>(distanceFromPrevKm),
      'durationFromPrevMin': serializer.toJson<int?>(durationFromPrevMin),
    };
  }

  MissionStep copyWith(
          {int? id,
          int? missionId,
          int? stepOrder,
          String? type,
          String? locationName,
          String? city,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<double?> distanceFromPrevKm = const Value.absent(),
          Value<int?> durationFromPrevMin = const Value.absent()}) =>
      MissionStep(
        id: id ?? this.id,
        missionId: missionId ?? this.missionId,
        stepOrder: stepOrder ?? this.stepOrder,
        type: type ?? this.type,
        locationName: locationName ?? this.locationName,
        city: city ?? this.city,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        distanceFromPrevKm: distanceFromPrevKm.present
            ? distanceFromPrevKm.value
            : this.distanceFromPrevKm,
        durationFromPrevMin: durationFromPrevMin.present
            ? durationFromPrevMin.value
            : this.durationFromPrevMin,
      );
  MissionStep copyWithCompanion(MissionStepsCompanion data) {
    return MissionStep(
      id: data.id.present ? data.id.value : this.id,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
      type: data.type.present ? data.type.value : this.type,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      city: data.city.present ? data.city.value : this.city,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      distanceFromPrevKm: data.distanceFromPrevKm.present
          ? data.distanceFromPrevKm.value
          : this.distanceFromPrevKm,
      durationFromPrevMin: data.durationFromPrevMin.present
          ? data.durationFromPrevMin.value
          : this.durationFromPrevMin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MissionStep(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('type: $type, ')
          ..write('locationName: $locationName, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('distanceFromPrevKm: $distanceFromPrevKm, ')
          ..write('durationFromPrevMin: $durationFromPrevMin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, missionId, stepOrder, type, locationName,
      city, latitude, longitude, distanceFromPrevKm, durationFromPrevMin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MissionStep &&
          other.id == this.id &&
          other.missionId == this.missionId &&
          other.stepOrder == this.stepOrder &&
          other.type == this.type &&
          other.locationName == this.locationName &&
          other.city == this.city &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.distanceFromPrevKm == this.distanceFromPrevKm &&
          other.durationFromPrevMin == this.durationFromPrevMin);
}

class MissionStepsCompanion extends UpdateCompanion<MissionStep> {
  final Value<int> id;
  final Value<int> missionId;
  final Value<int> stepOrder;
  final Value<String> type;
  final Value<String> locationName;
  final Value<String> city;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> distanceFromPrevKm;
  final Value<int?> durationFromPrevMin;
  const MissionStepsCompanion({
    this.id = const Value.absent(),
    this.missionId = const Value.absent(),
    this.stepOrder = const Value.absent(),
    this.type = const Value.absent(),
    this.locationName = const Value.absent(),
    this.city = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.distanceFromPrevKm = const Value.absent(),
    this.durationFromPrevMin = const Value.absent(),
  });
  MissionStepsCompanion.insert({
    this.id = const Value.absent(),
    required int missionId,
    required int stepOrder,
    required String type,
    required String locationName,
    required String city,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.distanceFromPrevKm = const Value.absent(),
    this.durationFromPrevMin = const Value.absent(),
  })  : missionId = Value(missionId),
        stepOrder = Value(stepOrder),
        type = Value(type),
        locationName = Value(locationName),
        city = Value(city);
  static Insertable<MissionStep> custom({
    Expression<int>? id,
    Expression<int>? missionId,
    Expression<int>? stepOrder,
    Expression<String>? type,
    Expression<String>? locationName,
    Expression<String>? city,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? distanceFromPrevKm,
    Expression<int>? durationFromPrevMin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (missionId != null) 'mission_id': missionId,
      if (stepOrder != null) 'step_order': stepOrder,
      if (type != null) 'type': type,
      if (locationName != null) 'location_name': locationName,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (distanceFromPrevKm != null)
        'distance_from_prev_km': distanceFromPrevKm,
      if (durationFromPrevMin != null)
        'duration_from_prev_min': durationFromPrevMin,
    });
  }

  MissionStepsCompanion copyWith(
      {Value<int>? id,
      Value<int>? missionId,
      Value<int>? stepOrder,
      Value<String>? type,
      Value<String>? locationName,
      Value<String>? city,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<double?>? distanceFromPrevKm,
      Value<int?>? durationFromPrevMin}) {
    return MissionStepsCompanion(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      stepOrder: stepOrder ?? this.stepOrder,
      type: type ?? this.type,
      locationName: locationName ?? this.locationName,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceFromPrevKm: distanceFromPrevKm ?? this.distanceFromPrevKm,
      durationFromPrevMin: durationFromPrevMin ?? this.durationFromPrevMin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<int>(missionId.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (distanceFromPrevKm.present) {
      map['distance_from_prev_km'] = Variable<double>(distanceFromPrevKm.value);
    }
    if (durationFromPrevMin.present) {
      map['duration_from_prev_min'] = Variable<int>(durationFromPrevMin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MissionStepsCompanion(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('type: $type, ')
          ..write('locationName: $locationName, ')
          ..write('city: $city, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('distanceFromPrevKm: $distanceFromPrevKm, ')
          ..write('durationFromPrevMin: $durationFromPrevMin')
          ..write(')'))
        .toString();
  }
}

class $NotificationLogsTable extends NotificationLogs
    with TableInfo<$NotificationLogsTable, NotificationLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _missionIdMeta =
      const VerificationMeta('missionId');
  @override
  late final GeneratedColumn<int> missionId = GeneratedColumn<int>(
      'mission_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES missions (id)'));
  static const VerificationMeta _recipientTypeMeta =
      const VerificationMeta('recipientType');
  @override
  late final GeneratedColumn<String> recipientType = GeneratedColumn<String>(
      'recipient_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientIdMeta =
      const VerificationMeta('recipientId');
  @override
  late final GeneratedColumn<int> recipientId = GeneratedColumn<int>(
      'recipient_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _recipientNameMeta =
      const VerificationMeta('recipientName');
  @override
  late final GeneratedColumn<String> recipientName = GeneratedColumn<String>(
      'recipient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipientPhoneMeta =
      const VerificationMeta('recipientPhone');
  @override
  late final GeneratedColumn<String> recipientPhone = GeneratedColumn<String>(
      'recipient_phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageContentMeta =
      const VerificationMeta('messageContent');
  @override
  late final GeneratedColumn<String> messageContent = GeneratedColumn<String>(
      'message_content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _whatsappUrlMeta =
      const VerificationMeta('whatsappUrl');
  @override
  late final GeneratedColumn<String> whatsappUrl = GeneratedColumn<String>(
      'whatsapp_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('GENERE'));
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _openedAtMeta =
      const VerificationMeta('openedAt');
  @override
  late final GeneratedColumn<DateTime> openedAt = GeneratedColumn<DateTime>(
      'opened_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _markedSentAtMeta =
      const VerificationMeta('markedSentAt');
  @override
  late final GeneratedColumn<DateTime> markedSentAt = GeneratedColumn<DateTime>(
      'marked_sent_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        missionId,
        recipientType,
        recipientId,
        recipientName,
        recipientPhone,
        messageContent,
        whatsappUrl,
        status,
        generatedAt,
        openedAt,
        markedSentAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_logs';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('mission_id')) {
      context.handle(_missionIdMeta,
          missionId.isAcceptableOrUnknown(data['mission_id']!, _missionIdMeta));
    } else if (isInserting) {
      context.missing(_missionIdMeta);
    }
    if (data.containsKey('recipient_type')) {
      context.handle(
          _recipientTypeMeta,
          recipientType.isAcceptableOrUnknown(
              data['recipient_type']!, _recipientTypeMeta));
    } else if (isInserting) {
      context.missing(_recipientTypeMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
          _recipientIdMeta,
          recipientId.isAcceptableOrUnknown(
              data['recipient_id']!, _recipientIdMeta));
    } else if (isInserting) {
      context.missing(_recipientIdMeta);
    }
    if (data.containsKey('recipient_name')) {
      context.handle(
          _recipientNameMeta,
          recipientName.isAcceptableOrUnknown(
              data['recipient_name']!, _recipientNameMeta));
    } else if (isInserting) {
      context.missing(_recipientNameMeta);
    }
    if (data.containsKey('recipient_phone')) {
      context.handle(
          _recipientPhoneMeta,
          recipientPhone.isAcceptableOrUnknown(
              data['recipient_phone']!, _recipientPhoneMeta));
    } else if (isInserting) {
      context.missing(_recipientPhoneMeta);
    }
    if (data.containsKey('message_content')) {
      context.handle(
          _messageContentMeta,
          messageContent.isAcceptableOrUnknown(
              data['message_content']!, _messageContentMeta));
    } else if (isInserting) {
      context.missing(_messageContentMeta);
    }
    if (data.containsKey('whatsapp_url')) {
      context.handle(
          _whatsappUrlMeta,
          whatsappUrl.isAcceptableOrUnknown(
              data['whatsapp_url']!, _whatsappUrlMeta));
    } else if (isInserting) {
      context.missing(_whatsappUrlMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    }
    if (data.containsKey('opened_at')) {
      context.handle(_openedAtMeta,
          openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta));
    }
    if (data.containsKey('marked_sent_at')) {
      context.handle(
          _markedSentAtMeta,
          markedSentAt.isAcceptableOrUnknown(
              data['marked_sent_at']!, _markedSentAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      missionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mission_id'])!,
      recipientType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_type'])!,
      recipientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipient_id'])!,
      recipientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipient_name'])!,
      recipientPhone: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recipient_phone'])!,
      messageContent: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}message_content'])!,
      whatsappUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}whatsapp_url'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
      openedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}opened_at']),
      markedSentAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}marked_sent_at']),
    );
  }

  @override
  $NotificationLogsTable createAlias(String alias) {
    return $NotificationLogsTable(attachedDatabase, alias);
  }
}

class NotificationLog extends DataClass implements Insertable<NotificationLog> {
  final int id;
  final int missionId;
  final String recipientType;
  final int recipientId;
  final String recipientName;
  final String recipientPhone;
  final String messageContent;
  final String whatsappUrl;
  final String status;
  final DateTime generatedAt;
  final DateTime? openedAt;
  final DateTime? markedSentAt;
  const NotificationLog(
      {required this.id,
      required this.missionId,
      required this.recipientType,
      required this.recipientId,
      required this.recipientName,
      required this.recipientPhone,
      required this.messageContent,
      required this.whatsappUrl,
      required this.status,
      required this.generatedAt,
      this.openedAt,
      this.markedSentAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mission_id'] = Variable<int>(missionId);
    map['recipient_type'] = Variable<String>(recipientType);
    map['recipient_id'] = Variable<int>(recipientId);
    map['recipient_name'] = Variable<String>(recipientName);
    map['recipient_phone'] = Variable<String>(recipientPhone);
    map['message_content'] = Variable<String>(messageContent);
    map['whatsapp_url'] = Variable<String>(whatsappUrl);
    map['status'] = Variable<String>(status);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    if (!nullToAbsent || openedAt != null) {
      map['opened_at'] = Variable<DateTime>(openedAt);
    }
    if (!nullToAbsent || markedSentAt != null) {
      map['marked_sent_at'] = Variable<DateTime>(markedSentAt);
    }
    return map;
  }

  NotificationLogsCompanion toCompanion(bool nullToAbsent) {
    return NotificationLogsCompanion(
      id: Value(id),
      missionId: Value(missionId),
      recipientType: Value(recipientType),
      recipientId: Value(recipientId),
      recipientName: Value(recipientName),
      recipientPhone: Value(recipientPhone),
      messageContent: Value(messageContent),
      whatsappUrl: Value(whatsappUrl),
      status: Value(status),
      generatedAt: Value(generatedAt),
      openedAt: openedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(openedAt),
      markedSentAt: markedSentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(markedSentAt),
    );
  }

  factory NotificationLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationLog(
      id: serializer.fromJson<int>(json['id']),
      missionId: serializer.fromJson<int>(json['missionId']),
      recipientType: serializer.fromJson<String>(json['recipientType']),
      recipientId: serializer.fromJson<int>(json['recipientId']),
      recipientName: serializer.fromJson<String>(json['recipientName']),
      recipientPhone: serializer.fromJson<String>(json['recipientPhone']),
      messageContent: serializer.fromJson<String>(json['messageContent']),
      whatsappUrl: serializer.fromJson<String>(json['whatsappUrl']),
      status: serializer.fromJson<String>(json['status']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      openedAt: serializer.fromJson<DateTime?>(json['openedAt']),
      markedSentAt: serializer.fromJson<DateTime?>(json['markedSentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'missionId': serializer.toJson<int>(missionId),
      'recipientType': serializer.toJson<String>(recipientType),
      'recipientId': serializer.toJson<int>(recipientId),
      'recipientName': serializer.toJson<String>(recipientName),
      'recipientPhone': serializer.toJson<String>(recipientPhone),
      'messageContent': serializer.toJson<String>(messageContent),
      'whatsappUrl': serializer.toJson<String>(whatsappUrl),
      'status': serializer.toJson<String>(status),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'openedAt': serializer.toJson<DateTime?>(openedAt),
      'markedSentAt': serializer.toJson<DateTime?>(markedSentAt),
    };
  }

  NotificationLog copyWith(
          {int? id,
          int? missionId,
          String? recipientType,
          int? recipientId,
          String? recipientName,
          String? recipientPhone,
          String? messageContent,
          String? whatsappUrl,
          String? status,
          DateTime? generatedAt,
          Value<DateTime?> openedAt = const Value.absent(),
          Value<DateTime?> markedSentAt = const Value.absent()}) =>
      NotificationLog(
        id: id ?? this.id,
        missionId: missionId ?? this.missionId,
        recipientType: recipientType ?? this.recipientType,
        recipientId: recipientId ?? this.recipientId,
        recipientName: recipientName ?? this.recipientName,
        recipientPhone: recipientPhone ?? this.recipientPhone,
        messageContent: messageContent ?? this.messageContent,
        whatsappUrl: whatsappUrl ?? this.whatsappUrl,
        status: status ?? this.status,
        generatedAt: generatedAt ?? this.generatedAt,
        openedAt: openedAt.present ? openedAt.value : this.openedAt,
        markedSentAt:
            markedSentAt.present ? markedSentAt.value : this.markedSentAt,
      );
  NotificationLog copyWithCompanion(NotificationLogsCompanion data) {
    return NotificationLog(
      id: data.id.present ? data.id.value : this.id,
      missionId: data.missionId.present ? data.missionId.value : this.missionId,
      recipientType: data.recipientType.present
          ? data.recipientType.value
          : this.recipientType,
      recipientId:
          data.recipientId.present ? data.recipientId.value : this.recipientId,
      recipientName: data.recipientName.present
          ? data.recipientName.value
          : this.recipientName,
      recipientPhone: data.recipientPhone.present
          ? data.recipientPhone.value
          : this.recipientPhone,
      messageContent: data.messageContent.present
          ? data.messageContent.value
          : this.messageContent,
      whatsappUrl:
          data.whatsappUrl.present ? data.whatsappUrl.value : this.whatsappUrl,
      status: data.status.present ? data.status.value : this.status,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      markedSentAt: data.markedSentAt.present
          ? data.markedSentAt.value
          : this.markedSentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLog(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('recipientType: $recipientType, ')
          ..write('recipientId: $recipientId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientPhone: $recipientPhone, ')
          ..write('messageContent: $messageContent, ')
          ..write('whatsappUrl: $whatsappUrl, ')
          ..write('status: $status, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('openedAt: $openedAt, ')
          ..write('markedSentAt: $markedSentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      missionId,
      recipientType,
      recipientId,
      recipientName,
      recipientPhone,
      messageContent,
      whatsappUrl,
      status,
      generatedAt,
      openedAt,
      markedSentAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationLog &&
          other.id == this.id &&
          other.missionId == this.missionId &&
          other.recipientType == this.recipientType &&
          other.recipientId == this.recipientId &&
          other.recipientName == this.recipientName &&
          other.recipientPhone == this.recipientPhone &&
          other.messageContent == this.messageContent &&
          other.whatsappUrl == this.whatsappUrl &&
          other.status == this.status &&
          other.generatedAt == this.generatedAt &&
          other.openedAt == this.openedAt &&
          other.markedSentAt == this.markedSentAt);
}

class NotificationLogsCompanion extends UpdateCompanion<NotificationLog> {
  final Value<int> id;
  final Value<int> missionId;
  final Value<String> recipientType;
  final Value<int> recipientId;
  final Value<String> recipientName;
  final Value<String> recipientPhone;
  final Value<String> messageContent;
  final Value<String> whatsappUrl;
  final Value<String> status;
  final Value<DateTime> generatedAt;
  final Value<DateTime?> openedAt;
  final Value<DateTime?> markedSentAt;
  const NotificationLogsCompanion({
    this.id = const Value.absent(),
    this.missionId = const Value.absent(),
    this.recipientType = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.recipientName = const Value.absent(),
    this.recipientPhone = const Value.absent(),
    this.messageContent = const Value.absent(),
    this.whatsappUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.markedSentAt = const Value.absent(),
  });
  NotificationLogsCompanion.insert({
    this.id = const Value.absent(),
    required int missionId,
    required String recipientType,
    required int recipientId,
    required String recipientName,
    required String recipientPhone,
    required String messageContent,
    required String whatsappUrl,
    this.status = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.markedSentAt = const Value.absent(),
  })  : missionId = Value(missionId),
        recipientType = Value(recipientType),
        recipientId = Value(recipientId),
        recipientName = Value(recipientName),
        recipientPhone = Value(recipientPhone),
        messageContent = Value(messageContent),
        whatsappUrl = Value(whatsappUrl);
  static Insertable<NotificationLog> custom({
    Expression<int>? id,
    Expression<int>? missionId,
    Expression<String>? recipientType,
    Expression<int>? recipientId,
    Expression<String>? recipientName,
    Expression<String>? recipientPhone,
    Expression<String>? messageContent,
    Expression<String>? whatsappUrl,
    Expression<String>? status,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? openedAt,
    Expression<DateTime>? markedSentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (missionId != null) 'mission_id': missionId,
      if (recipientType != null) 'recipient_type': recipientType,
      if (recipientId != null) 'recipient_id': recipientId,
      if (recipientName != null) 'recipient_name': recipientName,
      if (recipientPhone != null) 'recipient_phone': recipientPhone,
      if (messageContent != null) 'message_content': messageContent,
      if (whatsappUrl != null) 'whatsapp_url': whatsappUrl,
      if (status != null) 'status': status,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (openedAt != null) 'opened_at': openedAt,
      if (markedSentAt != null) 'marked_sent_at': markedSentAt,
    });
  }

  NotificationLogsCompanion copyWith(
      {Value<int>? id,
      Value<int>? missionId,
      Value<String>? recipientType,
      Value<int>? recipientId,
      Value<String>? recipientName,
      Value<String>? recipientPhone,
      Value<String>? messageContent,
      Value<String>? whatsappUrl,
      Value<String>? status,
      Value<DateTime>? generatedAt,
      Value<DateTime?>? openedAt,
      Value<DateTime?>? markedSentAt}) {
    return NotificationLogsCompanion(
      id: id ?? this.id,
      missionId: missionId ?? this.missionId,
      recipientType: recipientType ?? this.recipientType,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      messageContent: messageContent ?? this.messageContent,
      whatsappUrl: whatsappUrl ?? this.whatsappUrl,
      status: status ?? this.status,
      generatedAt: generatedAt ?? this.generatedAt,
      openedAt: openedAt ?? this.openedAt,
      markedSentAt: markedSentAt ?? this.markedSentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (missionId.present) {
      map['mission_id'] = Variable<int>(missionId.value);
    }
    if (recipientType.present) {
      map['recipient_type'] = Variable<String>(recipientType.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<int>(recipientId.value);
    }
    if (recipientName.present) {
      map['recipient_name'] = Variable<String>(recipientName.value);
    }
    if (recipientPhone.present) {
      map['recipient_phone'] = Variable<String>(recipientPhone.value);
    }
    if (messageContent.present) {
      map['message_content'] = Variable<String>(messageContent.value);
    }
    if (whatsappUrl.present) {
      map['whatsapp_url'] = Variable<String>(whatsappUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<DateTime>(openedAt.value);
    }
    if (markedSentAt.present) {
      map['marked_sent_at'] = Variable<DateTime>(markedSentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationLogsCompanion(')
          ..write('id: $id, ')
          ..write('missionId: $missionId, ')
          ..write('recipientType: $recipientType, ')
          ..write('recipientId: $recipientId, ')
          ..write('recipientName: $recipientName, ')
          ..write('recipientPhone: $recipientPhone, ')
          ..write('messageContent: $messageContent, ')
          ..write('whatsappUrl: $whatsappUrl, ')
          ..write('status: $status, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('openedAt: $openedAt, ')
          ..write('markedSentAt: $markedSentAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String key;
  final String value;
  final DateTime updatedAt;
  const Setting(
      {required this.id,
      required this.key,
      required this.value,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith(
          {int? id, String? key, String? value, DateTime? updatedAt}) =>
      Setting(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? value,
      Value<DateTime>? updatedAt}) {
    return SettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DriversTable drivers = $DriversTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $PassengersTable passengers = $PassengersTable(this);
  late final $KnownLocationsTable knownLocations = $KnownLocationsTable(this);
  late final $MissionsTable missions = $MissionsTable(this);
  late final $MissionPassengersTable missionPassengers =
      $MissionPassengersTable(this);
  late final $MissionStepsTable missionSteps = $MissionStepsTable(this);
  late final $NotificationLogsTable notificationLogs =
      $NotificationLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final DriverDao driverDao = DriverDao(this as AppDatabase);
  late final VehicleDao vehicleDao = VehicleDao(this as AppDatabase);
  late final PassengerDao passengerDao = PassengerDao(this as AppDatabase);
  late final KnownLocationDao knownLocationDao =
      KnownLocationDao(this as AppDatabase);
  late final MissionDao missionDao = MissionDao(this as AppDatabase);
  late final MissionPassengerDao missionPassengerDao =
      MissionPassengerDao(this as AppDatabase);
  late final MissionStepDao missionStepDao =
      MissionStepDao(this as AppDatabase);
  late final NotificationLogDao notificationLogDao =
      NotificationLogDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        drivers,
        vehicles,
        passengers,
        knownLocations,
        missions,
        missionPassengers,
        missionSteps,
        notificationLogs,
        settings
      ];
}

typedef $$DriversTableCreateCompanionBuilder = DriversCompanion Function({
  Value<int> id,
  required String name,
  required String phone,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$DriversTableUpdateCompanionBuilder = DriversCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> phone,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$DriversTableReferences
    extends BaseReferences<_$AppDatabase, $DriversTable, Driver> {
  $$DriversTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionsTable, List<Mission>> _missionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.missions,
          aliasName: $_aliasNameGenerator(db.drivers.id, db.missions.driverId));

  $$MissionsTableProcessedTableManager get missionsRefs {
    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.driverId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DriversTableFilterComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> missionsRefs(
      Expression<bool> Function($$MissionsTableFilterComposer f) f) {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.driverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriversTableOrderingComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$DriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> missionsRefs<T extends Object>(
      Expression<T> Function($$MissionsTableAnnotationComposer a) f) {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.driverId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DriversTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DriversTable,
    Driver,
    $$DriversTableFilterComposer,
    $$DriversTableOrderingComposer,
    $$DriversTableAnnotationComposer,
    $$DriversTableCreateCompanionBuilder,
    $$DriversTableUpdateCompanionBuilder,
    (Driver, $$DriversTableReferences),
    Driver,
    PrefetchHooks Function({bool missionsRefs})> {
  $$DriversTableTableManager(_$AppDatabase db, $DriversTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DriversCompanion(
            id: id,
            name: name,
            phone: phone,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String phone,
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              DriversCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DriversTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({missionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (missionsRefs) db.missions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missionsRefs)
                    await $_getPrefetchedData<Driver, $DriversTable, Mission>(
                        currentTable: table,
                        referencedTable:
                            $$DriversTableReferences._missionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DriversTableReferences(db, table, p0)
                                .missionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.driverId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DriversTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DriversTable,
    Driver,
    $$DriversTableFilterComposer,
    $$DriversTableOrderingComposer,
    $$DriversTableAnnotationComposer,
    $$DriversTableCreateCompanionBuilder,
    $$DriversTableUpdateCompanionBuilder,
    (Driver, $$DriversTableReferences),
    Driver,
    PrefetchHooks Function({bool missionsRefs})>;
typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  required String brand,
  required String plateNumber,
  Value<int> capacity,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<int> id,
  Value<String> brand,
  Value<String> plateNumber,
  Value<int> capacity,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionsTable, List<Mission>> _missionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.missions,
          aliasName:
              $_aliasNameGenerator(db.vehicles.id, db.missions.vehicleId));

  $$MissionsTableProcessedTableManager get missionsRefs {
    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> missionsRefs(
      Expression<bool> Function($$MissionsTableFilterComposer f) f) {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.vehicleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get capacity => $composableBuilder(
      column: $table.capacity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get plateNumber => $composableBuilder(
      column: $table.plateNumber, builder: (column) => column);

  GeneratedColumn<int> get capacity =>
      $composableBuilder(column: $table.capacity, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> missionsRefs<T extends Object>(
      Expression<T> Function($$MissionsTableAnnotationComposer a) f) {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.vehicleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VehiclesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, $$VehiclesTableReferences),
    Vehicle,
    PrefetchHooks Function({bool missionsRefs})> {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> brand = const Value.absent(),
            Value<String> plateNumber = const Value.absent(),
            Value<int> capacity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VehiclesCompanion(
            id: id,
            brand: brand,
            plateNumber: plateNumber,
            capacity: capacity,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String brand,
            required String plateNumber,
            Value<int> capacity = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              VehiclesCompanion.insert(
            id: id,
            brand: brand,
            plateNumber: plateNumber,
            capacity: capacity,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VehiclesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({missionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (missionsRefs) db.missions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missionsRefs)
                    await $_getPrefetchedData<Vehicle, $VehiclesTable, Mission>(
                        currentTable: table,
                        referencedTable:
                            $$VehiclesTableReferences._missionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VehiclesTableReferences(db, table, p0)
                                .missionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.vehicleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VehiclesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VehiclesTable,
    Vehicle,
    $$VehiclesTableFilterComposer,
    $$VehiclesTableOrderingComposer,
    $$VehiclesTableAnnotationComposer,
    $$VehiclesTableCreateCompanionBuilder,
    $$VehiclesTableUpdateCompanionBuilder,
    (Vehicle, $$VehiclesTableReferences),
    Vehicle,
    PrefetchHooks Function({bool missionsRefs})>;
typedef $$PassengersTableCreateCompanionBuilder = PassengersCompanion Function({
  Value<int> id,
  required String name,
  required String role,
  required String phone,
  required String baseCity,
  Value<double?> baseLat,
  Value<double?> baseLng,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});
typedef $$PassengersTableUpdateCompanionBuilder = PassengersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> role,
  Value<String> phone,
  Value<String> baseCity,
  Value<double?> baseLat,
  Value<double?> baseLng,
  Value<bool> isActive,
  Value<DateTime> createdAt,
});

final class $$PassengersTableReferences
    extends BaseReferences<_$AppDatabase, $PassengersTable, Passenger> {
  $$PassengersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionPassengersTable, List<MissionPassenger>>
      _missionPassengersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.missionPassengers,
              aliasName: $_aliasNameGenerator(
                  db.passengers.id, db.missionPassengers.passengerId));

  $$MissionPassengersTableProcessedTableManager get missionPassengersRefs {
    final manager = $$MissionPassengersTableTableManager(
            $_db, $_db.missionPassengers)
        .filter((f) => f.passengerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_missionPassengersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PassengersTableFilterComposer
    extends Composer<_$AppDatabase, $PassengersTable> {
  $$PassengersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCity => $composableBuilder(
      column: $table.baseCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseLat => $composableBuilder(
      column: $table.baseLat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseLng => $composableBuilder(
      column: $table.baseLng, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> missionPassengersRefs(
      Expression<bool> Function($$MissionPassengersTableFilterComposer f) f) {
    final $$MissionPassengersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missionPassengers,
        getReferencedColumn: (t) => t.passengerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionPassengersTableFilterComposer(
              $db: $db,
              $table: $db.missionPassengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PassengersTableOrderingComposer
    extends Composer<_$AppDatabase, $PassengersTable> {
  $$PassengersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCity => $composableBuilder(
      column: $table.baseCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseLat => $composableBuilder(
      column: $table.baseLat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseLng => $composableBuilder(
      column: $table.baseLng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$PassengersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassengersTable> {
  $$PassengersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get baseCity =>
      $composableBuilder(column: $table.baseCity, builder: (column) => column);

  GeneratedColumn<double> get baseLat =>
      $composableBuilder(column: $table.baseLat, builder: (column) => column);

  GeneratedColumn<double> get baseLng =>
      $composableBuilder(column: $table.baseLng, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> missionPassengersRefs<T extends Object>(
      Expression<T> Function($$MissionPassengersTableAnnotationComposer a) f) {
    final $$MissionPassengersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.missionPassengers,
            getReferencedColumn: (t) => t.passengerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MissionPassengersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.missionPassengers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PassengersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PassengersTable,
    Passenger,
    $$PassengersTableFilterComposer,
    $$PassengersTableOrderingComposer,
    $$PassengersTableAnnotationComposer,
    $$PassengersTableCreateCompanionBuilder,
    $$PassengersTableUpdateCompanionBuilder,
    (Passenger, $$PassengersTableReferences),
    Passenger,
    PrefetchHooks Function({bool missionPassengersRefs})> {
  $$PassengersTableTableManager(_$AppDatabase db, $PassengersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PassengersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PassengersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PassengersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> baseCity = const Value.absent(),
            Value<double?> baseLat = const Value.absent(),
            Value<double?> baseLng = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PassengersCompanion(
            id: id,
            name: name,
            role: role,
            phone: phone,
            baseCity: baseCity,
            baseLat: baseLat,
            baseLng: baseLng,
            isActive: isActive,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String role,
            required String phone,
            required String baseCity,
            Value<double?> baseLat = const Value.absent(),
            Value<double?> baseLng = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              PassengersCompanion.insert(
            id: id,
            name: name,
            role: role,
            phone: phone,
            baseCity: baseCity,
            baseLat: baseLat,
            baseLng: baseLng,
            isActive: isActive,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PassengersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({missionPassengersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (missionPassengersRefs) db.missionPassengers
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missionPassengersRefs)
                    await $_getPrefetchedData<Passenger, $PassengersTable,
                            MissionPassenger>(
                        currentTable: table,
                        referencedTable: $$PassengersTableReferences
                            ._missionPassengersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PassengersTableReferences(db, table, p0)
                                .missionPassengersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.passengerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PassengersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PassengersTable,
    Passenger,
    $$PassengersTableFilterComposer,
    $$PassengersTableOrderingComposer,
    $$PassengersTableAnnotationComposer,
    $$PassengersTableCreateCompanionBuilder,
    $$PassengersTableUpdateCompanionBuilder,
    (Passenger, $$PassengersTableReferences),
    Passenger,
    PrefetchHooks Function({bool missionPassengersRefs})>;
typedef $$KnownLocationsTableCreateCompanionBuilder = KnownLocationsCompanion
    Function({
  Value<int> id,
  required String name,
  required String shortCode,
  required String city,
  required double latitude,
  required double longitude,
  Value<bool> isAirport,
  Value<bool> isActive,
});
typedef $$KnownLocationsTableUpdateCompanionBuilder = KnownLocationsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> shortCode,
  Value<String> city,
  Value<double> latitude,
  Value<double> longitude,
  Value<bool> isAirport,
  Value<bool> isActive,
});

final class $$KnownLocationsTableReferences
    extends BaseReferences<_$AppDatabase, $KnownLocationsTable, KnownLocation> {
  $$KnownLocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MissionsTable, List<Mission>> _missionsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.missions,
          aliasName: $_aliasNameGenerator(
              db.knownLocations.id, db.missions.destinationId));

  $$MissionsTableProcessedTableManager get missionsRefs {
    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.destinationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MissionPassengersTable, List<MissionPassenger>>
      _missionPassengersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.missionPassengers,
              aliasName: $_aliasNameGenerator(
                  db.knownLocations.id, db.missionPassengers.pickupLocationId));

  $$MissionPassengersTableProcessedTableManager get missionPassengersRefs {
    final manager = $$MissionPassengersTableTableManager(
            $_db, $_db.missionPassengers)
        .filter(
            (f) => f.pickupLocationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_missionPassengersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$KnownLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $KnownLocationsTable> {
  $$KnownLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortCode => $composableBuilder(
      column: $table.shortCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAirport => $composableBuilder(
      column: $table.isAirport, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> missionsRefs(
      Expression<bool> Function($$MissionsTableFilterComposer f) f) {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.destinationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> missionPassengersRefs(
      Expression<bool> Function($$MissionPassengersTableFilterComposer f) f) {
    final $$MissionPassengersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missionPassengers,
        getReferencedColumn: (t) => t.pickupLocationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionPassengersTableFilterComposer(
              $db: $db,
              $table: $db.missionPassengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$KnownLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $KnownLocationsTable> {
  $$KnownLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortCode => $composableBuilder(
      column: $table.shortCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAirport => $composableBuilder(
      column: $table.isAirport, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$KnownLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KnownLocationsTable> {
  $$KnownLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get shortCode =>
      $composableBuilder(column: $table.shortCode, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<bool> get isAirport =>
      $composableBuilder(column: $table.isAirport, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> missionsRefs<T extends Object>(
      Expression<T> Function($$MissionsTableAnnotationComposer a) f) {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.destinationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> missionPassengersRefs<T extends Object>(
      Expression<T> Function($$MissionPassengersTableAnnotationComposer a) f) {
    final $$MissionPassengersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.missionPassengers,
            getReferencedColumn: (t) => t.pickupLocationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MissionPassengersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.missionPassengers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$KnownLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $KnownLocationsTable,
    KnownLocation,
    $$KnownLocationsTableFilterComposer,
    $$KnownLocationsTableOrderingComposer,
    $$KnownLocationsTableAnnotationComposer,
    $$KnownLocationsTableCreateCompanionBuilder,
    $$KnownLocationsTableUpdateCompanionBuilder,
    (KnownLocation, $$KnownLocationsTableReferences),
    KnownLocation,
    PrefetchHooks Function({bool missionsRefs, bool missionPassengersRefs})> {
  $$KnownLocationsTableTableManager(
      _$AppDatabase db, $KnownLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KnownLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KnownLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KnownLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> shortCode = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<double> latitude = const Value.absent(),
            Value<double> longitude = const Value.absent(),
            Value<bool> isAirport = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              KnownLocationsCompanion(
            id: id,
            name: name,
            shortCode: shortCode,
            city: city,
            latitude: latitude,
            longitude: longitude,
            isAirport: isAirport,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String shortCode,
            required String city,
            required double latitude,
            required double longitude,
            Value<bool> isAirport = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              KnownLocationsCompanion.insert(
            id: id,
            name: name,
            shortCode: shortCode,
            city: city,
            latitude: latitude,
            longitude: longitude,
            isAirport: isAirport,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$KnownLocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {missionsRefs = false, missionPassengersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (missionsRefs) db.missions,
                if (missionPassengersRefs) db.missionPassengers
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missionsRefs)
                    await $_getPrefetchedData<KnownLocation,
                            $KnownLocationsTable, Mission>(
                        currentTable: table,
                        referencedTable: $$KnownLocationsTableReferences
                            ._missionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnownLocationsTableReferences(db, table, p0)
                                .missionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.destinationId == item.id),
                        typedResults: items),
                  if (missionPassengersRefs)
                    await $_getPrefetchedData<KnownLocation,
                            $KnownLocationsTable, MissionPassenger>(
                        currentTable: table,
                        referencedTable: $$KnownLocationsTableReferences
                            ._missionPassengersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$KnownLocationsTableReferences(db, table, p0)
                                .missionPassengersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.pickupLocationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$KnownLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $KnownLocationsTable,
    KnownLocation,
    $$KnownLocationsTableFilterComposer,
    $$KnownLocationsTableOrderingComposer,
    $$KnownLocationsTableAnnotationComposer,
    $$KnownLocationsTableCreateCompanionBuilder,
    $$KnownLocationsTableUpdateCompanionBuilder,
    (KnownLocation, $$KnownLocationsTableReferences),
    KnownLocation,
    PrefetchHooks Function({bool missionsRefs, bool missionPassengersRefs})>;
typedef $$MissionsTableCreateCompanionBuilder = MissionsCompanion Function({
  Value<int> id,
  required String reference,
  required String type,
  required int driverId,
  required int vehicleId,
  required int destinationId,
  required DateTime scheduledAt,
  Value<String> status,
  Value<double?> totalDistanceKm,
  Value<int?> estimatedDurationMin,
  Value<String?> googleMapsUrl,
  Value<bool> returnToBase,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$MissionsTableUpdateCompanionBuilder = MissionsCompanion Function({
  Value<int> id,
  Value<String> reference,
  Value<String> type,
  Value<int> driverId,
  Value<int> vehicleId,
  Value<int> destinationId,
  Value<DateTime> scheduledAt,
  Value<String> status,
  Value<double?> totalDistanceKm,
  Value<int?> estimatedDurationMin,
  Value<String?> googleMapsUrl,
  Value<bool> returnToBase,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$MissionsTableReferences
    extends BaseReferences<_$AppDatabase, $MissionsTable, Mission> {
  $$MissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DriversTable _driverIdTable(_$AppDatabase db) => db.drivers
      .createAlias($_aliasNameGenerator(db.missions.driverId, db.drivers.id));

  $$DriversTableProcessedTableManager get driverId {
    final $_column = $_itemColumn<int>('driver_id')!;

    final manager = $$DriversTableTableManager($_db, $_db.drivers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_driverIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) => db.vehicles
      .createAlias($_aliasNameGenerator(db.missions.vehicleId, db.vehicles.id));

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager($_db, $_db.vehicles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $KnownLocationsTable _destinationIdTable(_$AppDatabase db) =>
      db.knownLocations.createAlias($_aliasNameGenerator(
          db.missions.destinationId, db.knownLocations.id));

  $$KnownLocationsTableProcessedTableManager get destinationId {
    final $_column = $_itemColumn<int>('destination_id')!;

    final manager = $$KnownLocationsTableTableManager($_db, $_db.knownLocations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_destinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MissionPassengersTable, List<MissionPassenger>>
      _missionPassengersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.missionPassengers,
              aliasName: $_aliasNameGenerator(
                  db.missions.id, db.missionPassengers.missionId));

  $$MissionPassengersTableProcessedTableManager get missionPassengersRefs {
    final manager =
        $$MissionPassengersTableTableManager($_db, $_db.missionPassengers)
            .filter((f) => f.missionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_missionPassengersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MissionStepsTable, List<MissionStep>>
      _missionStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.missionSteps,
          aliasName:
              $_aliasNameGenerator(db.missions.id, db.missionSteps.missionId));

  $$MissionStepsTableProcessedTableManager get missionStepsRefs {
    final manager = $$MissionStepsTableTableManager($_db, $_db.missionSteps)
        .filter((f) => f.missionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_missionStepsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotificationLogsTable, List<NotificationLog>>
      _notificationLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.notificationLogs,
              aliasName: $_aliasNameGenerator(
                  db.missions.id, db.notificationLogs.missionId));

  $$NotificationLogsTableProcessedTableManager get notificationLogsRefs {
    final manager =
        $$NotificationLogsTableTableManager($_db, $_db.notificationLogs)
            .filter((f) => f.missionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_notificationLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MissionsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedDurationMin => $composableBuilder(
      column: $table.estimatedDurationMin,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get googleMapsUrl => $composableBuilder(
      column: $table.googleMapsUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get returnToBase => $composableBuilder(
      column: $table.returnToBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$DriversTableFilterComposer get driverId {
    final $$DriversTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.driverId,
        referencedTable: $db.drivers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriversTableFilterComposer(
              $db: $db,
              $table: $db.drivers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehicleId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableFilterComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableFilterComposer get destinationId {
    final $$KnownLocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableFilterComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> missionPassengersRefs(
      Expression<bool> Function($$MissionPassengersTableFilterComposer f) f) {
    final $$MissionPassengersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missionPassengers,
        getReferencedColumn: (t) => t.missionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionPassengersTableFilterComposer(
              $db: $db,
              $table: $db.missionPassengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> missionStepsRefs(
      Expression<bool> Function($$MissionStepsTableFilterComposer f) f) {
    final $$MissionStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missionSteps,
        getReferencedColumn: (t) => t.missionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionStepsTableFilterComposer(
              $db: $db,
              $table: $db.missionSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> notificationLogsRefs(
      Expression<bool> Function($$NotificationLogsTableFilterComposer f) f) {
    final $$NotificationLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notificationLogs,
        getReferencedColumn: (t) => t.missionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotificationLogsTableFilterComposer(
              $db: $db,
              $table: $db.notificationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedDurationMin => $composableBuilder(
      column: $table.estimatedDurationMin,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get googleMapsUrl => $composableBuilder(
      column: $table.googleMapsUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get returnToBase => $composableBuilder(
      column: $table.returnToBase,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$DriversTableOrderingComposer get driverId {
    final $$DriversTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.driverId,
        referencedTable: $db.drivers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriversTableOrderingComposer(
              $db: $db,
              $table: $db.drivers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehicleId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableOrderingComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableOrderingComposer get destinationId {
    final $$KnownLocationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableOrderingComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionsTable> {
  $$MissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalDistanceKm => $composableBuilder(
      column: $table.totalDistanceKm, builder: (column) => column);

  GeneratedColumn<int> get estimatedDurationMin => $composableBuilder(
      column: $table.estimatedDurationMin, builder: (column) => column);

  GeneratedColumn<String> get googleMapsUrl => $composableBuilder(
      column: $table.googleMapsUrl, builder: (column) => column);

  GeneratedColumn<bool> get returnToBase => $composableBuilder(
      column: $table.returnToBase, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DriversTableAnnotationComposer get driverId {
    final $$DriversTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.driverId,
        referencedTable: $db.drivers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DriversTableAnnotationComposer(
              $db: $db,
              $table: $db.drivers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vehicleId,
        referencedTable: $db.vehicles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VehiclesTableAnnotationComposer(
              $db: $db,
              $table: $db.vehicles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableAnnotationComposer get destinationId {
    final $$KnownLocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.destinationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> missionPassengersRefs<T extends Object>(
      Expression<T> Function($$MissionPassengersTableAnnotationComposer a) f) {
    final $$MissionPassengersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.missionPassengers,
            getReferencedColumn: (t) => t.missionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MissionPassengersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.missionPassengers,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> missionStepsRefs<T extends Object>(
      Expression<T> Function($$MissionStepsTableAnnotationComposer a) f) {
    final $$MissionStepsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.missionSteps,
        getReferencedColumn: (t) => t.missionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionStepsTableAnnotationComposer(
              $db: $db,
              $table: $db.missionSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> notificationLogsRefs<T extends Object>(
      Expression<T> Function($$NotificationLogsTableAnnotationComposer a) f) {
    final $$NotificationLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notificationLogs,
        getReferencedColumn: (t) => t.missionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotificationLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.notificationLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MissionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MissionsTable,
    Mission,
    $$MissionsTableFilterComposer,
    $$MissionsTableOrderingComposer,
    $$MissionsTableAnnotationComposer,
    $$MissionsTableCreateCompanionBuilder,
    $$MissionsTableUpdateCompanionBuilder,
    (Mission, $$MissionsTableReferences),
    Mission,
    PrefetchHooks Function(
        {bool driverId,
        bool vehicleId,
        bool destinationId,
        bool missionPassengersRefs,
        bool missionStepsRefs,
        bool notificationLogsRefs})> {
  $$MissionsTableTableManager(_$AppDatabase db, $MissionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> reference = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> driverId = const Value.absent(),
            Value<int> vehicleId = const Value.absent(),
            Value<int> destinationId = const Value.absent(),
            Value<DateTime> scheduledAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double?> totalDistanceKm = const Value.absent(),
            Value<int?> estimatedDurationMin = const Value.absent(),
            Value<String?> googleMapsUrl = const Value.absent(),
            Value<bool> returnToBase = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MissionsCompanion(
            id: id,
            reference: reference,
            type: type,
            driverId: driverId,
            vehicleId: vehicleId,
            destinationId: destinationId,
            scheduledAt: scheduledAt,
            status: status,
            totalDistanceKm: totalDistanceKm,
            estimatedDurationMin: estimatedDurationMin,
            googleMapsUrl: googleMapsUrl,
            returnToBase: returnToBase,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String reference,
            required String type,
            required int driverId,
            required int vehicleId,
            required int destinationId,
            required DateTime scheduledAt,
            Value<String> status = const Value.absent(),
            Value<double?> totalDistanceKm = const Value.absent(),
            Value<int?> estimatedDurationMin = const Value.absent(),
            Value<String?> googleMapsUrl = const Value.absent(),
            Value<bool> returnToBase = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              MissionsCompanion.insert(
            id: id,
            reference: reference,
            type: type,
            driverId: driverId,
            vehicleId: vehicleId,
            destinationId: destinationId,
            scheduledAt: scheduledAt,
            status: status,
            totalDistanceKm: totalDistanceKm,
            estimatedDurationMin: estimatedDurationMin,
            googleMapsUrl: googleMapsUrl,
            returnToBase: returnToBase,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MissionsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {driverId = false,
              vehicleId = false,
              destinationId = false,
              missionPassengersRefs = false,
              missionStepsRefs = false,
              notificationLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (missionPassengersRefs) db.missionPassengers,
                if (missionStepsRefs) db.missionSteps,
                if (notificationLogsRefs) db.notificationLogs
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (driverId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.driverId,
                    referencedTable:
                        $$MissionsTableReferences._driverIdTable(db),
                    referencedColumn:
                        $$MissionsTableReferences._driverIdTable(db).id,
                  ) as T;
                }
                if (vehicleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vehicleId,
                    referencedTable:
                        $$MissionsTableReferences._vehicleIdTable(db),
                    referencedColumn:
                        $$MissionsTableReferences._vehicleIdTable(db).id,
                  ) as T;
                }
                if (destinationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.destinationId,
                    referencedTable:
                        $$MissionsTableReferences._destinationIdTable(db),
                    referencedColumn:
                        $$MissionsTableReferences._destinationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (missionPassengersRefs)
                    await $_getPrefetchedData<Mission, $MissionsTable,
                            MissionPassenger>(
                        currentTable: table,
                        referencedTable: $$MissionsTableReferences
                            ._missionPassengersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MissionsTableReferences(db, table, p0)
                                .missionPassengersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.missionId == item.id),
                        typedResults: items),
                  if (missionStepsRefs)
                    await $_getPrefetchedData<Mission, $MissionsTable,
                            MissionStep>(
                        currentTable: table,
                        referencedTable: $$MissionsTableReferences
                            ._missionStepsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MissionsTableReferences(db, table, p0)
                                .missionStepsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.missionId == item.id),
                        typedResults: items),
                  if (notificationLogsRefs)
                    await $_getPrefetchedData<Mission, $MissionsTable,
                            NotificationLog>(
                        currentTable: table,
                        referencedTable: $$MissionsTableReferences
                            ._notificationLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MissionsTableReferences(db, table, p0)
                                .notificationLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.missionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MissionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MissionsTable,
    Mission,
    $$MissionsTableFilterComposer,
    $$MissionsTableOrderingComposer,
    $$MissionsTableAnnotationComposer,
    $$MissionsTableCreateCompanionBuilder,
    $$MissionsTableUpdateCompanionBuilder,
    (Mission, $$MissionsTableReferences),
    Mission,
    PrefetchHooks Function(
        {bool driverId,
        bool vehicleId,
        bool destinationId,
        bool missionPassengersRefs,
        bool missionStepsRefs,
        bool notificationLogsRefs})>;
typedef $$MissionPassengersTableCreateCompanionBuilder
    = MissionPassengersCompanion Function({
  Value<int> id,
  required int missionId,
  Value<int?> passengerId,
  Value<String?> guestName,
  Value<String?> guestPhone,
  Value<int?> pickupLocationId,
  Value<String?> pickupCity,
  Value<int> pickupOrder,
  Value<String> whatsappStatus,
});
typedef $$MissionPassengersTableUpdateCompanionBuilder
    = MissionPassengersCompanion Function({
  Value<int> id,
  Value<int> missionId,
  Value<int?> passengerId,
  Value<String?> guestName,
  Value<String?> guestPhone,
  Value<int?> pickupLocationId,
  Value<String?> pickupCity,
  Value<int> pickupOrder,
  Value<String> whatsappStatus,
});

final class $$MissionPassengersTableReferences extends BaseReferences<
    _$AppDatabase, $MissionPassengersTable, MissionPassenger> {
  $$MissionPassengersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MissionsTable _missionIdTable(_$AppDatabase db) =>
      db.missions.createAlias(
          $_aliasNameGenerator(db.missionPassengers.missionId, db.missions.id));

  $$MissionsTableProcessedTableManager get missionId {
    final $_column = $_itemColumn<int>('mission_id')!;

    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_missionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PassengersTable _passengerIdTable(_$AppDatabase db) =>
      db.passengers.createAlias($_aliasNameGenerator(
          db.missionPassengers.passengerId, db.passengers.id));

  $$PassengersTableProcessedTableManager? get passengerId {
    final $_column = $_itemColumn<int>('passenger_id');
    if ($_column == null) return null;
    final manager = $$PassengersTableTableManager($_db, $_db.passengers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_passengerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $KnownLocationsTable _pickupLocationIdTable(_$AppDatabase db) =>
      db.knownLocations.createAlias($_aliasNameGenerator(
          db.missionPassengers.pickupLocationId, db.knownLocations.id));

  $$KnownLocationsTableProcessedTableManager? get pickupLocationId {
    final $_column = $_itemColumn<int>('pickup_location_id');
    if ($_column == null) return null;
    final manager = $$KnownLocationsTableTableManager($_db, $_db.knownLocations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_pickupLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MissionPassengersTableFilterComposer
    extends Composer<_$AppDatabase, $MissionPassengersTable> {
  $$MissionPassengersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestPhone => $composableBuilder(
      column: $table.guestPhone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pickupCity => $composableBuilder(
      column: $table.pickupCity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pickupOrder => $composableBuilder(
      column: $table.pickupOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsappStatus => $composableBuilder(
      column: $table.whatsappStatus,
      builder: (column) => ColumnFilters(column));

  $$MissionsTableFilterComposer get missionId {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PassengersTableFilterComposer get passengerId {
    final $$PassengersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.passengerId,
        referencedTable: $db.passengers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PassengersTableFilterComposer(
              $db: $db,
              $table: $db.passengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableFilterComposer get pickupLocationId {
    final $$KnownLocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pickupLocationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableFilterComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionPassengersTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionPassengersTable> {
  $$MissionPassengersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestPhone => $composableBuilder(
      column: $table.guestPhone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pickupCity => $composableBuilder(
      column: $table.pickupCity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pickupOrder => $composableBuilder(
      column: $table.pickupOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsappStatus => $composableBuilder(
      column: $table.whatsappStatus,
      builder: (column) => ColumnOrderings(column));

  $$MissionsTableOrderingComposer get missionId {
    final $$MissionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableOrderingComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PassengersTableOrderingComposer get passengerId {
    final $$PassengersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.passengerId,
        referencedTable: $db.passengers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PassengersTableOrderingComposer(
              $db: $db,
              $table: $db.passengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableOrderingComposer get pickupLocationId {
    final $$KnownLocationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pickupLocationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableOrderingComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionPassengersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionPassengersTable> {
  $$MissionPassengersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get guestName =>
      $composableBuilder(column: $table.guestName, builder: (column) => column);

  GeneratedColumn<String> get guestPhone => $composableBuilder(
      column: $table.guestPhone, builder: (column) => column);

  GeneratedColumn<String> get pickupCity => $composableBuilder(
      column: $table.pickupCity, builder: (column) => column);

  GeneratedColumn<int> get pickupOrder => $composableBuilder(
      column: $table.pickupOrder, builder: (column) => column);

  GeneratedColumn<String> get whatsappStatus => $composableBuilder(
      column: $table.whatsappStatus, builder: (column) => column);

  $$MissionsTableAnnotationComposer get missionId {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PassengersTableAnnotationComposer get passengerId {
    final $$PassengersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.passengerId,
        referencedTable: $db.passengers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PassengersTableAnnotationComposer(
              $db: $db,
              $table: $db.passengers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$KnownLocationsTableAnnotationComposer get pickupLocationId {
    final $$KnownLocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.pickupLocationId,
        referencedTable: $db.knownLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$KnownLocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.knownLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionPassengersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MissionPassengersTable,
    MissionPassenger,
    $$MissionPassengersTableFilterComposer,
    $$MissionPassengersTableOrderingComposer,
    $$MissionPassengersTableAnnotationComposer,
    $$MissionPassengersTableCreateCompanionBuilder,
    $$MissionPassengersTableUpdateCompanionBuilder,
    (MissionPassenger, $$MissionPassengersTableReferences),
    MissionPassenger,
    PrefetchHooks Function(
        {bool missionId, bool passengerId, bool pickupLocationId})> {
  $$MissionPassengersTableTableManager(
      _$AppDatabase db, $MissionPassengersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionPassengersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionPassengersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionPassengersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> missionId = const Value.absent(),
            Value<int?> passengerId = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<String?> guestPhone = const Value.absent(),
            Value<int?> pickupLocationId = const Value.absent(),
            Value<String?> pickupCity = const Value.absent(),
            Value<int> pickupOrder = const Value.absent(),
            Value<String> whatsappStatus = const Value.absent(),
          }) =>
              MissionPassengersCompanion(
            id: id,
            missionId: missionId,
            passengerId: passengerId,
            guestName: guestName,
            guestPhone: guestPhone,
            pickupLocationId: pickupLocationId,
            pickupCity: pickupCity,
            pickupOrder: pickupOrder,
            whatsappStatus: whatsappStatus,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int missionId,
            Value<int?> passengerId = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<String?> guestPhone = const Value.absent(),
            Value<int?> pickupLocationId = const Value.absent(),
            Value<String?> pickupCity = const Value.absent(),
            Value<int> pickupOrder = const Value.absent(),
            Value<String> whatsappStatus = const Value.absent(),
          }) =>
              MissionPassengersCompanion.insert(
            id: id,
            missionId: missionId,
            passengerId: passengerId,
            guestName: guestName,
            guestPhone: guestPhone,
            pickupLocationId: pickupLocationId,
            pickupCity: pickupCity,
            pickupOrder: pickupOrder,
            whatsappStatus: whatsappStatus,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MissionPassengersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {missionId = false,
              passengerId = false,
              pickupLocationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (missionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.missionId,
                    referencedTable:
                        $$MissionPassengersTableReferences._missionIdTable(db),
                    referencedColumn: $$MissionPassengersTableReferences
                        ._missionIdTable(db)
                        .id,
                  ) as T;
                }
                if (passengerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.passengerId,
                    referencedTable: $$MissionPassengersTableReferences
                        ._passengerIdTable(db),
                    referencedColumn: $$MissionPassengersTableReferences
                        ._passengerIdTable(db)
                        .id,
                  ) as T;
                }
                if (pickupLocationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.pickupLocationId,
                    referencedTable: $$MissionPassengersTableReferences
                        ._pickupLocationIdTable(db),
                    referencedColumn: $$MissionPassengersTableReferences
                        ._pickupLocationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MissionPassengersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MissionPassengersTable,
    MissionPassenger,
    $$MissionPassengersTableFilterComposer,
    $$MissionPassengersTableOrderingComposer,
    $$MissionPassengersTableAnnotationComposer,
    $$MissionPassengersTableCreateCompanionBuilder,
    $$MissionPassengersTableUpdateCompanionBuilder,
    (MissionPassenger, $$MissionPassengersTableReferences),
    MissionPassenger,
    PrefetchHooks Function(
        {bool missionId, bool passengerId, bool pickupLocationId})>;
typedef $$MissionStepsTableCreateCompanionBuilder = MissionStepsCompanion
    Function({
  Value<int> id,
  required int missionId,
  required int stepOrder,
  required String type,
  required String locationName,
  required String city,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> distanceFromPrevKm,
  Value<int?> durationFromPrevMin,
});
typedef $$MissionStepsTableUpdateCompanionBuilder = MissionStepsCompanion
    Function({
  Value<int> id,
  Value<int> missionId,
  Value<int> stepOrder,
  Value<String> type,
  Value<String> locationName,
  Value<String> city,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<double?> distanceFromPrevKm,
  Value<int?> durationFromPrevMin,
});

final class $$MissionStepsTableReferences
    extends BaseReferences<_$AppDatabase, $MissionStepsTable, MissionStep> {
  $$MissionStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MissionsTable _missionIdTable(_$AppDatabase db) =>
      db.missions.createAlias(
          $_aliasNameGenerator(db.missionSteps.missionId, db.missions.id));

  $$MissionsTableProcessedTableManager get missionId {
    final $_column = $_itemColumn<int>('mission_id')!;

    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_missionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MissionStepsTableFilterComposer
    extends Composer<_$AppDatabase, $MissionStepsTable> {
  $$MissionStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distanceFromPrevKm => $composableBuilder(
      column: $table.distanceFromPrevKm,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationFromPrevMin => $composableBuilder(
      column: $table.durationFromPrevMin,
      builder: (column) => ColumnFilters(column));

  $$MissionsTableFilterComposer get missionId {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $MissionStepsTable> {
  $$MissionStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distanceFromPrevKm => $composableBuilder(
      column: $table.distanceFromPrevKm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationFromPrevMin => $composableBuilder(
      column: $table.durationFromPrevMin,
      builder: (column) => ColumnOrderings(column));

  $$MissionsTableOrderingComposer get missionId {
    final $$MissionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableOrderingComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MissionStepsTable> {
  $$MissionStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get distanceFromPrevKm => $composableBuilder(
      column: $table.distanceFromPrevKm, builder: (column) => column);

  GeneratedColumn<int> get durationFromPrevMin => $composableBuilder(
      column: $table.durationFromPrevMin, builder: (column) => column);

  $$MissionsTableAnnotationComposer get missionId {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MissionStepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MissionStepsTable,
    MissionStep,
    $$MissionStepsTableFilterComposer,
    $$MissionStepsTableOrderingComposer,
    $$MissionStepsTableAnnotationComposer,
    $$MissionStepsTableCreateCompanionBuilder,
    $$MissionStepsTableUpdateCompanionBuilder,
    (MissionStep, $$MissionStepsTableReferences),
    MissionStep,
    PrefetchHooks Function({bool missionId})> {
  $$MissionStepsTableTableManager(_$AppDatabase db, $MissionStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MissionStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MissionStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MissionStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> missionId = const Value.absent(),
            Value<int> stepOrder = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> locationName = const Value.absent(),
            Value<String> city = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> distanceFromPrevKm = const Value.absent(),
            Value<int?> durationFromPrevMin = const Value.absent(),
          }) =>
              MissionStepsCompanion(
            id: id,
            missionId: missionId,
            stepOrder: stepOrder,
            type: type,
            locationName: locationName,
            city: city,
            latitude: latitude,
            longitude: longitude,
            distanceFromPrevKm: distanceFromPrevKm,
            durationFromPrevMin: durationFromPrevMin,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int missionId,
            required int stepOrder,
            required String type,
            required String locationName,
            required String city,
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<double?> distanceFromPrevKm = const Value.absent(),
            Value<int?> durationFromPrevMin = const Value.absent(),
          }) =>
              MissionStepsCompanion.insert(
            id: id,
            missionId: missionId,
            stepOrder: stepOrder,
            type: type,
            locationName: locationName,
            city: city,
            latitude: latitude,
            longitude: longitude,
            distanceFromPrevKm: distanceFromPrevKm,
            durationFromPrevMin: durationFromPrevMin,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MissionStepsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({missionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (missionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.missionId,
                    referencedTable:
                        $$MissionStepsTableReferences._missionIdTable(db),
                    referencedColumn:
                        $$MissionStepsTableReferences._missionIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MissionStepsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MissionStepsTable,
    MissionStep,
    $$MissionStepsTableFilterComposer,
    $$MissionStepsTableOrderingComposer,
    $$MissionStepsTableAnnotationComposer,
    $$MissionStepsTableCreateCompanionBuilder,
    $$MissionStepsTableUpdateCompanionBuilder,
    (MissionStep, $$MissionStepsTableReferences),
    MissionStep,
    PrefetchHooks Function({bool missionId})>;
typedef $$NotificationLogsTableCreateCompanionBuilder
    = NotificationLogsCompanion Function({
  Value<int> id,
  required int missionId,
  required String recipientType,
  required int recipientId,
  required String recipientName,
  required String recipientPhone,
  required String messageContent,
  required String whatsappUrl,
  Value<String> status,
  Value<DateTime> generatedAt,
  Value<DateTime?> openedAt,
  Value<DateTime?> markedSentAt,
});
typedef $$NotificationLogsTableUpdateCompanionBuilder
    = NotificationLogsCompanion Function({
  Value<int> id,
  Value<int> missionId,
  Value<String> recipientType,
  Value<int> recipientId,
  Value<String> recipientName,
  Value<String> recipientPhone,
  Value<String> messageContent,
  Value<String> whatsappUrl,
  Value<String> status,
  Value<DateTime> generatedAt,
  Value<DateTime?> openedAt,
  Value<DateTime?> markedSentAt,
});

final class $$NotificationLogsTableReferences extends BaseReferences<
    _$AppDatabase, $NotificationLogsTable, NotificationLog> {
  $$NotificationLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MissionsTable _missionIdTable(_$AppDatabase db) =>
      db.missions.createAlias(
          $_aliasNameGenerator(db.notificationLogs.missionId, db.missions.id));

  $$MissionsTableProcessedTableManager get missionId {
    final $_column = $_itemColumn<int>('mission_id')!;

    final manager = $$MissionsTableTableManager($_db, $_db.missions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_missionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotificationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientType => $composableBuilder(
      column: $table.recipientType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipientPhone => $composableBuilder(
      column: $table.recipientPhone,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageContent => $composableBuilder(
      column: $table.messageContent,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get whatsappUrl => $composableBuilder(
      column: $table.whatsappUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get markedSentAt => $composableBuilder(
      column: $table.markedSentAt, builder: (column) => ColumnFilters(column));

  $$MissionsTableFilterComposer get missionId {
    final $$MissionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableFilterComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientType => $composableBuilder(
      column: $table.recipientType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientName => $composableBuilder(
      column: $table.recipientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipientPhone => $composableBuilder(
      column: $table.recipientPhone,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageContent => $composableBuilder(
      column: $table.messageContent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get whatsappUrl => $composableBuilder(
      column: $table.whatsappUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get openedAt => $composableBuilder(
      column: $table.openedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get markedSentAt => $composableBuilder(
      column: $table.markedSentAt,
      builder: (column) => ColumnOrderings(column));

  $$MissionsTableOrderingComposer get missionId {
    final $$MissionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableOrderingComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationLogsTable> {
  $$NotificationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipientType => $composableBuilder(
      column: $table.recipientType, builder: (column) => column);

  GeneratedColumn<int> get recipientId => $composableBuilder(
      column: $table.recipientId, builder: (column) => column);

  GeneratedColumn<String> get recipientName => $composableBuilder(
      column: $table.recipientName, builder: (column) => column);

  GeneratedColumn<String> get recipientPhone => $composableBuilder(
      column: $table.recipientPhone, builder: (column) => column);

  GeneratedColumn<String> get messageContent => $composableBuilder(
      column: $table.messageContent, builder: (column) => column);

  GeneratedColumn<String> get whatsappUrl => $composableBuilder(
      column: $table.whatsappUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
      column: $table.generatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get markedSentAt => $composableBuilder(
      column: $table.markedSentAt, builder: (column) => column);

  $$MissionsTableAnnotationComposer get missionId {
    final $$MissionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.missionId,
        referencedTable: $db.missions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MissionsTableAnnotationComposer(
              $db: $db,
              $table: $db.missions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotificationLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationLogsTable,
    NotificationLog,
    $$NotificationLogsTableFilterComposer,
    $$NotificationLogsTableOrderingComposer,
    $$NotificationLogsTableAnnotationComposer,
    $$NotificationLogsTableCreateCompanionBuilder,
    $$NotificationLogsTableUpdateCompanionBuilder,
    (NotificationLog, $$NotificationLogsTableReferences),
    NotificationLog,
    PrefetchHooks Function({bool missionId})> {
  $$NotificationLogsTableTableManager(
      _$AppDatabase db, $NotificationLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> missionId = const Value.absent(),
            Value<String> recipientType = const Value.absent(),
            Value<int> recipientId = const Value.absent(),
            Value<String> recipientName = const Value.absent(),
            Value<String> recipientPhone = const Value.absent(),
            Value<String> messageContent = const Value.absent(),
            Value<String> whatsappUrl = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<DateTime?> openedAt = const Value.absent(),
            Value<DateTime?> markedSentAt = const Value.absent(),
          }) =>
              NotificationLogsCompanion(
            id: id,
            missionId: missionId,
            recipientType: recipientType,
            recipientId: recipientId,
            recipientName: recipientName,
            recipientPhone: recipientPhone,
            messageContent: messageContent,
            whatsappUrl: whatsappUrl,
            status: status,
            generatedAt: generatedAt,
            openedAt: openedAt,
            markedSentAt: markedSentAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int missionId,
            required String recipientType,
            required int recipientId,
            required String recipientName,
            required String recipientPhone,
            required String messageContent,
            required String whatsappUrl,
            Value<String> status = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<DateTime?> openedAt = const Value.absent(),
            Value<DateTime?> markedSentAt = const Value.absent(),
          }) =>
              NotificationLogsCompanion.insert(
            id: id,
            missionId: missionId,
            recipientType: recipientType,
            recipientId: recipientId,
            recipientName: recipientName,
            recipientPhone: recipientPhone,
            messageContent: messageContent,
            whatsappUrl: whatsappUrl,
            status: status,
            generatedAt: generatedAt,
            openedAt: openedAt,
            markedSentAt: markedSentAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NotificationLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({missionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (missionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.missionId,
                    referencedTable:
                        $$NotificationLogsTableReferences._missionIdTable(db),
                    referencedColumn: $$NotificationLogsTableReferences
                        ._missionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotificationLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationLogsTable,
    NotificationLog,
    $$NotificationLogsTableFilterComposer,
    $$NotificationLogsTableOrderingComposer,
    $$NotificationLogsTableAnnotationComposer,
    $$NotificationLogsTableCreateCompanionBuilder,
    $$NotificationLogsTableUpdateCompanionBuilder,
    (NotificationLog, $$NotificationLogsTableReferences),
    NotificationLog,
    PrefetchHooks Function({bool missionId})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  required String key,
  required String value,
  Value<DateTime> updatedAt,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
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
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
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
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
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
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            key: key,
            value: value,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String value,
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            id: id,
            key: key,
            value: value,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
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
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db, _db.drivers);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$PassengersTableTableManager get passengers =>
      $$PassengersTableTableManager(_db, _db.passengers);
  $$KnownLocationsTableTableManager get knownLocations =>
      $$KnownLocationsTableTableManager(_db, _db.knownLocations);
  $$MissionsTableTableManager get missions =>
      $$MissionsTableTableManager(_db, _db.missions);
  $$MissionPassengersTableTableManager get missionPassengers =>
      $$MissionPassengersTableTableManager(_db, _db.missionPassengers);
  $$MissionStepsTableTableManager get missionSteps =>
      $$MissionStepsTableTableManager(_db, _db.missionSteps);
  $$NotificationLogsTableTableManager get notificationLogs =>
      $$NotificationLogsTableTableManager(_db, _db.notificationLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
