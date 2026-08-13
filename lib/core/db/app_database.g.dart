// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PropulsionType, String>
  propulsionType = GeneratedColumn<String>(
    'propulsion_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PropulsionType>($VehiclesTable.$converterpropulsionType);
  static const VerificationMeta _acquisitionDateMeta = const VerificationMeta(
    'acquisitionDate',
  );
  @override
  late final GeneratedColumn<int> acquisitionDate = GeneratedColumn<int>(
    'acquisition_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _initialMileageMeta = const VerificationMeta(
    'initialMileage',
  );
  @override
  late final GeneratedColumn<int> initialMileage = GeneratedColumn<int>(
    'initial_mileage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    propulsionType,
    acquisitionDate,
    initialMileage,
    isArchived,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('acquisition_date')) {
      context.handle(
        _acquisitionDateMeta,
        acquisitionDate.isAcceptableOrUnknown(
          data['acquisition_date']!,
          _acquisitionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_acquisitionDateMeta);
    }
    if (data.containsKey('initial_mileage')) {
      context.handle(
        _initialMileageMeta,
        initialMileage.isAcceptableOrUnknown(
          data['initial_mileage']!,
          _initialMileageMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      propulsionType: $VehiclesTable.$converterpropulsionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}propulsion_type'],
        )!,
      ),
      acquisitionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}acquisition_date'],
      )!,
      initialMileage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_mileage'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }

  static TypeConverter<PropulsionType, String> $converterpropulsionType =
      const PropulsionTypeConverter();
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final int id;
  final String name;
  final PropulsionType propulsionType;

  /// Acquisition date, packed as yyyyMMdd (CarGo convention).
  final int acquisitionDate;

  /// Odometer reading when the vehicle was acquired (km).
  final int initialMileage;
  final bool isArchived;
  final int? sortOrder;
  const Vehicle({
    required this.id,
    required this.name,
    required this.propulsionType,
    required this.acquisitionDate,
    required this.initialMileage,
    required this.isArchived,
    this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['propulsion_type'] = Variable<String>(
        $VehiclesTable.$converterpropulsionType.toSql(propulsionType),
      );
    }
    map['acquisition_date'] = Variable<int>(acquisitionDate);
    map['initial_mileage'] = Variable<int>(initialMileage);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || sortOrder != null) {
      map['sort_order'] = Variable<int>(sortOrder);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      name: Value(name),
      propulsionType: Value(propulsionType),
      acquisitionDate: Value(acquisitionDate),
      initialMileage: Value(initialMileage),
      isArchived: Value(isArchived),
      sortOrder: sortOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(sortOrder),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      propulsionType: serializer.fromJson<PropulsionType>(
        json['propulsionType'],
      ),
      acquisitionDate: serializer.fromJson<int>(json['acquisitionDate']),
      initialMileage: serializer.fromJson<int>(json['initialMileage']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      sortOrder: serializer.fromJson<int?>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'propulsionType': serializer.toJson<PropulsionType>(propulsionType),
      'acquisitionDate': serializer.toJson<int>(acquisitionDate),
      'initialMileage': serializer.toJson<int>(initialMileage),
      'isArchived': serializer.toJson<bool>(isArchived),
      'sortOrder': serializer.toJson<int?>(sortOrder),
    };
  }

  Vehicle copyWith({
    int? id,
    String? name,
    PropulsionType? propulsionType,
    int? acquisitionDate,
    int? initialMileage,
    bool? isArchived,
    Value<int?> sortOrder = const Value.absent(),
  }) => Vehicle(
    id: id ?? this.id,
    name: name ?? this.name,
    propulsionType: propulsionType ?? this.propulsionType,
    acquisitionDate: acquisitionDate ?? this.acquisitionDate,
    initialMileage: initialMileage ?? this.initialMileage,
    isArchived: isArchived ?? this.isArchived,
    sortOrder: sortOrder.present ? sortOrder.value : this.sortOrder,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      propulsionType: data.propulsionType.present
          ? data.propulsionType.value
          : this.propulsionType,
      acquisitionDate: data.acquisitionDate.present
          ? data.acquisitionDate.value
          : this.acquisitionDate,
      initialMileage: data.initialMileage.present
          ? data.initialMileage.value
          : this.initialMileage,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('propulsionType: $propulsionType, ')
          ..write('acquisitionDate: $acquisitionDate, ')
          ..write('initialMileage: $initialMileage, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    propulsionType,
    acquisitionDate,
    initialMileage,
    isArchived,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.name == this.name &&
          other.propulsionType == this.propulsionType &&
          other.acquisitionDate == this.acquisitionDate &&
          other.initialMileage == this.initialMileage &&
          other.isArchived == this.isArchived &&
          other.sortOrder == this.sortOrder);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<int> id;
  final Value<String> name;
  final Value<PropulsionType> propulsionType;
  final Value<int> acquisitionDate;
  final Value<int> initialMileage;
  final Value<bool> isArchived;
  final Value<int?> sortOrder;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.propulsionType = const Value.absent(),
    this.acquisitionDate = const Value.absent(),
    this.initialMileage = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PropulsionType propulsionType,
    required int acquisitionDate,
    this.initialMileage = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name),
       propulsionType = Value(propulsionType),
       acquisitionDate = Value(acquisitionDate);
  static Insertable<Vehicle> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? propulsionType,
    Expression<int>? acquisitionDate,
    Expression<int>? initialMileage,
    Expression<bool>? isArchived,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (propulsionType != null) 'propulsion_type': propulsionType,
      if (acquisitionDate != null) 'acquisition_date': acquisitionDate,
      if (initialMileage != null) 'initial_mileage': initialMileage,
      if (isArchived != null) 'is_archived': isArchived,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  VehiclesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<PropulsionType>? propulsionType,
    Value<int>? acquisitionDate,
    Value<int>? initialMileage,
    Value<bool>? isArchived,
    Value<int?>? sortOrder,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      propulsionType: propulsionType ?? this.propulsionType,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      initialMileage: initialMileage ?? this.initialMileage,
      isArchived: isArchived ?? this.isArchived,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (propulsionType.present) {
      map['propulsion_type'] = Variable<String>(
        $VehiclesTable.$converterpropulsionType.toSql(propulsionType.value),
      );
    }
    if (acquisitionDate.present) {
      map['acquisition_date'] = Variable<int>(acquisitionDate.value);
    }
    if (initialMileage.present) {
      map['initial_mileage'] = Variable<int>(initialMileage.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('propulsionType: $propulsionType, ')
          ..write('acquisitionDate: $acquisitionDate, ')
          ..write('initialMileage: $initialMileage, ')
          ..write('isArchived: $isArchived, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $RefuelsTable extends Refuels with TableInfo<$RefuelsTable, Refuel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RefuelsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<double> cost = GeneratedColumn<double>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FuelType, String> fuelType =
      GeneratedColumn<String>(
        'fuel_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FuelType>($RefuelsTable.$converterfuelType);
  static const VerificationMeta _isFullMeta = const VerificationMeta('isFull');
  @override
  late final GeneratedColumn<bool> isFull = GeneratedColumn<bool>(
    'is_full',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_full" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _odometerMeta = const VerificationMeta(
    'odometer',
  );
  @override
  late final GeneratedColumn<int> odometer = GeneratedColumn<int>(
    'odometer',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    vehicleId,
    cost,
    amount,
    fuelType,
    isFull,
    odometer,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'refuels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Refuel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_full')) {
      context.handle(
        _isFullMeta,
        isFull.isAcceptableOrUnknown(data['is_full']!, _isFullMeta),
      );
    }
    if (data.containsKey('odometer')) {
      context.handle(
        _odometerMeta,
        odometer.isAcceptableOrUnknown(data['odometer']!, _odometerMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Refuel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Refuel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cost'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      fuelType: $RefuelsTable.$converterfuelType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fuel_type'],
        )!,
      ),
      isFull: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_full'],
      )!,
      odometer: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}odometer'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $RefuelsTable createAlias(String alias) {
    return $RefuelsTable(attachedDatabase, alias);
  }

  static TypeConverter<FuelType, String> $converterfuelType =
      const FuelTypeConverter();
}

class Refuel extends DataClass implements Insertable<Refuel> {
  final int id;

  /// Date packed as yyyyMMdd.
  final int date;
  final int vehicleId;

  /// Total price paid, in euro.
  final double cost;

  /// Litres (combustion) or kWh (electric).
  final double amount;
  final FuelType fuelType;

  /// Whether the tank/battery was filled completely (enables accurate
  /// full-to-full consumption). Defaults to true.
  final bool isFull;

  /// Optional odometer reading at the time of refuelling (km).
  final int? odometer;
  final String? note;
  const Refuel({
    required this.id,
    required this.date,
    required this.vehicleId,
    required this.cost,
    required this.amount,
    required this.fuelType,
    required this.isFull,
    this.odometer,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['cost'] = Variable<double>(cost);
    map['amount'] = Variable<double>(amount);
    {
      map['fuel_type'] = Variable<String>(
        $RefuelsTable.$converterfuelType.toSql(fuelType),
      );
    }
    map['is_full'] = Variable<bool>(isFull);
    if (!nullToAbsent || odometer != null) {
      map['odometer'] = Variable<int>(odometer);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  RefuelsCompanion toCompanion(bool nullToAbsent) {
    return RefuelsCompanion(
      id: Value(id),
      date: Value(date),
      vehicleId: Value(vehicleId),
      cost: Value(cost),
      amount: Value(amount),
      fuelType: Value(fuelType),
      isFull: Value(isFull),
      odometer: odometer == null && nullToAbsent
          ? const Value.absent()
          : Value(odometer),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Refuel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Refuel(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      cost: serializer.fromJson<double>(json['cost']),
      amount: serializer.fromJson<double>(json['amount']),
      fuelType: serializer.fromJson<FuelType>(json['fuelType']),
      isFull: serializer.fromJson<bool>(json['isFull']),
      odometer: serializer.fromJson<int?>(json['odometer']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'cost': serializer.toJson<double>(cost),
      'amount': serializer.toJson<double>(amount),
      'fuelType': serializer.toJson<FuelType>(fuelType),
      'isFull': serializer.toJson<bool>(isFull),
      'odometer': serializer.toJson<int?>(odometer),
      'note': serializer.toJson<String?>(note),
    };
  }

  Refuel copyWith({
    int? id,
    int? date,
    int? vehicleId,
    double? cost,
    double? amount,
    FuelType? fuelType,
    bool? isFull,
    Value<int?> odometer = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Refuel(
    id: id ?? this.id,
    date: date ?? this.date,
    vehicleId: vehicleId ?? this.vehicleId,
    cost: cost ?? this.cost,
    amount: amount ?? this.amount,
    fuelType: fuelType ?? this.fuelType,
    isFull: isFull ?? this.isFull,
    odometer: odometer.present ? odometer.value : this.odometer,
    note: note.present ? note.value : this.note,
  );
  Refuel copyWithCompanion(RefuelsCompanion data) {
    return Refuel(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      cost: data.cost.present ? data.cost.value : this.cost,
      amount: data.amount.present ? data.amount.value : this.amount,
      fuelType: data.fuelType.present ? data.fuelType.value : this.fuelType,
      isFull: data.isFull.present ? data.isFull.value : this.isFull,
      odometer: data.odometer.present ? data.odometer.value : this.odometer,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Refuel(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('cost: $cost, ')
          ..write('amount: $amount, ')
          ..write('fuelType: $fuelType, ')
          ..write('isFull: $isFull, ')
          ..write('odometer: $odometer, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    vehicleId,
    cost,
    amount,
    fuelType,
    isFull,
    odometer,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Refuel &&
          other.id == this.id &&
          other.date == this.date &&
          other.vehicleId == this.vehicleId &&
          other.cost == this.cost &&
          other.amount == this.amount &&
          other.fuelType == this.fuelType &&
          other.isFull == this.isFull &&
          other.odometer == this.odometer &&
          other.note == this.note);
}

class RefuelsCompanion extends UpdateCompanion<Refuel> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> vehicleId;
  final Value<double> cost;
  final Value<double> amount;
  final Value<FuelType> fuelType;
  final Value<bool> isFull;
  final Value<int?> odometer;
  final Value<String?> note;
  const RefuelsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.cost = const Value.absent(),
    this.amount = const Value.absent(),
    this.fuelType = const Value.absent(),
    this.isFull = const Value.absent(),
    this.odometer = const Value.absent(),
    this.note = const Value.absent(),
  });
  RefuelsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int vehicleId,
    required double cost,
    required double amount,
    required FuelType fuelType,
    this.isFull = const Value.absent(),
    this.odometer = const Value.absent(),
    this.note = const Value.absent(),
  }) : date = Value(date),
       vehicleId = Value(vehicleId),
       cost = Value(cost),
       amount = Value(amount),
       fuelType = Value(fuelType);
  static Insertable<Refuel> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? vehicleId,
    Expression<double>? cost,
    Expression<double>? amount,
    Expression<String>? fuelType,
    Expression<bool>? isFull,
    Expression<int>? odometer,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (cost != null) 'cost': cost,
      if (amount != null) 'amount': amount,
      if (fuelType != null) 'fuel_type': fuelType,
      if (isFull != null) 'is_full': isFull,
      if (odometer != null) 'odometer': odometer,
      if (note != null) 'note': note,
    });
  }

  RefuelsCompanion copyWith({
    Value<int>? id,
    Value<int>? date,
    Value<int>? vehicleId,
    Value<double>? cost,
    Value<double>? amount,
    Value<FuelType>? fuelType,
    Value<bool>? isFull,
    Value<int?>? odometer,
    Value<String?>? note,
  }) {
    return RefuelsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      vehicleId: vehicleId ?? this.vehicleId,
      cost: cost ?? this.cost,
      amount: amount ?? this.amount,
      fuelType: fuelType ?? this.fuelType,
      isFull: isFull ?? this.isFull,
      odometer: odometer ?? this.odometer,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (cost.present) {
      map['cost'] = Variable<double>(cost.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (fuelType.present) {
      map['fuel_type'] = Variable<String>(
        $RefuelsTable.$converterfuelType.toSql(fuelType.value),
      );
    }
    if (isFull.present) {
      map['is_full'] = Variable<bool>(isFull.value);
    }
    if (odometer.present) {
      map['odometer'] = Variable<int>(odometer.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RefuelsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('cost: $cost, ')
          ..write('amount: $amount, ')
          ..write('fuelType: $fuelType, ')
          ..write('isFull: $isFull, ')
          ..write('odometer: $odometer, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $OdometerReadingsTable extends OdometerReadings
    with TableInfo<$OdometerReadingsTable, OdometerReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OdometerReadingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleIdMeta = const VerificationMeta(
    'vehicleId',
  );
  @override
  late final GeneratedColumn<int> vehicleId = GeneratedColumn<int>(
    'vehicle_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES vehicles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, vehicleId, value, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'odometer_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<OdometerReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('vehicle_id')) {
      context.handle(
        _vehicleIdMeta,
        vehicleId.isAcceptableOrUnknown(data['vehicle_id']!, _vehicleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_vehicleIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OdometerReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OdometerReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      vehicleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vehicle_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OdometerReadingsTable createAlias(String alias) {
    return $OdometerReadingsTable(attachedDatabase, alias);
  }
}

class OdometerReading extends DataClass implements Insertable<OdometerReading> {
  final int id;

  /// Date packed as yyyyMMdd.
  final int date;
  final int vehicleId;

  /// Odometer value in kilometres.
  final int value;
  final String? note;
  const OdometerReading({
    required this.id,
    required this.date,
    required this.vehicleId,
    required this.value,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['vehicle_id'] = Variable<int>(vehicleId);
    map['value'] = Variable<int>(value);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OdometerReadingsCompanion toCompanion(bool nullToAbsent) {
    return OdometerReadingsCompanion(
      id: Value(id),
      date: Value(date),
      vehicleId: Value(vehicleId),
      value: Value(value),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory OdometerReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OdometerReading(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      vehicleId: serializer.fromJson<int>(json['vehicleId']),
      value: serializer.fromJson<int>(json['value']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'vehicleId': serializer.toJson<int>(vehicleId),
      'value': serializer.toJson<int>(value),
      'note': serializer.toJson<String?>(note),
    };
  }

  OdometerReading copyWith({
    int? id,
    int? date,
    int? vehicleId,
    int? value,
    Value<String?> note = const Value.absent(),
  }) => OdometerReading(
    id: id ?? this.id,
    date: date ?? this.date,
    vehicleId: vehicleId ?? this.vehicleId,
    value: value ?? this.value,
    note: note.present ? note.value : this.note,
  );
  OdometerReading copyWithCompanion(OdometerReadingsCompanion data) {
    return OdometerReading(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      vehicleId: data.vehicleId.present ? data.vehicleId.value : this.vehicleId,
      value: data.value.present ? data.value.value : this.value,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OdometerReading(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('value: $value, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, vehicleId, value, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OdometerReading &&
          other.id == this.id &&
          other.date == this.date &&
          other.vehicleId == this.vehicleId &&
          other.value == this.value &&
          other.note == this.note);
}

class OdometerReadingsCompanion extends UpdateCompanion<OdometerReading> {
  final Value<int> id;
  final Value<int> date;
  final Value<int> vehicleId;
  final Value<int> value;
  final Value<String?> note;
  const OdometerReadingsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.vehicleId = const Value.absent(),
    this.value = const Value.absent(),
    this.note = const Value.absent(),
  });
  OdometerReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required int vehicleId,
    required int value,
    this.note = const Value.absent(),
  }) : date = Value(date),
       vehicleId = Value(vehicleId),
       value = Value(value);
  static Insertable<OdometerReading> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<int>? vehicleId,
    Expression<int>? value,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (value != null) 'value': value,
      if (note != null) 'note': note,
    });
  }

  OdometerReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? date,
    Value<int>? vehicleId,
    Value<int>? value,
    Value<String?>? note,
  }) {
    return OdometerReadingsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      vehicleId: vehicleId ?? this.vehicleId,
      value: value ?? this.value,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (vehicleId.present) {
      map['vehicle_id'] = Variable<int>(vehicleId.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OdometerReadingsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('vehicleId: $vehicleId, ')
          ..write('value: $value, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $RefuelsTable refuels = $RefuelsTable(this);
  late final $OdometerReadingsTable odometerReadings = $OdometerReadingsTable(
    this,
  );
  late final VehicleDao vehicleDao = VehicleDao(this as AppDatabase);
  late final RefuelDao refuelDao = RefuelDao(this as AppDatabase);
  late final OdometerDao odometerDao = OdometerDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    vehicles,
    refuels,
    odometerReadings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('refuels', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'vehicles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('odometer_readings', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$VehiclesTableCreateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      required String name,
      required PropulsionType propulsionType,
      required int acquisitionDate,
      Value<int> initialMileage,
      Value<bool> isArchived,
      Value<int?> sortOrder,
    });
typedef $$VehiclesTableUpdateCompanionBuilder =
    VehiclesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<PropulsionType> propulsionType,
      Value<int> acquisitionDate,
      Value<int> initialMileage,
      Value<bool> isArchived,
      Value<int?> sortOrder,
    });

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RefuelsTable, List<Refuel>> _refuelsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.refuels,
    aliasName: 'vehicles__id__refuels__vehicle_id',
  );

  $$RefuelsTableProcessedTableManager get refuelsRefs {
    final manager = $$RefuelsTableTableManager(
      $_db,
      $_db.refuels,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_refuelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OdometerReadingsTable, List<OdometerReading>>
  _odometerReadingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.odometerReadings,
    aliasName: 'vehicles__id__odometer_readings__vehicle_id',
  );

  $$OdometerReadingsTableProcessedTableManager get odometerReadingsRefs {
    final manager = $$OdometerReadingsTableTableManager(
      $_db,
      $_db.odometerReadings,
    ).filter((f) => f.vehicleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _odometerReadingsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
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
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PropulsionType, PropulsionType, String>
  get propulsionType => $composableBuilder(
    column: $table.propulsionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get acquisitionDate => $composableBuilder(
    column: $table.acquisitionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get initialMileage => $composableBuilder(
    column: $table.initialMileage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> refuelsRefs(
    Expression<bool> Function($$RefuelsTableFilterComposer f) f,
  ) {
    final $$RefuelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refuels,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefuelsTableFilterComposer(
            $db: $db,
            $table: $db.refuels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> odometerReadingsRefs(
    Expression<bool> Function($$OdometerReadingsTableFilterComposer f) f,
  ) {
    final $$OdometerReadingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.odometerReadings,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OdometerReadingsTableFilterComposer(
            $db: $db,
            $table: $db.odometerReadings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
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
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propulsionType => $composableBuilder(
    column: $table.propulsionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get acquisitionDate => $composableBuilder(
    column: $table.acquisitionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialMileage => $composableBuilder(
    column: $table.initialMileage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PropulsionType, String> get propulsionType =>
      $composableBuilder(
        column: $table.propulsionType,
        builder: (column) => column,
      );

  GeneratedColumn<int> get acquisitionDate => $composableBuilder(
    column: $table.acquisitionDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get initialMileage => $composableBuilder(
    column: $table.initialMileage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> refuelsRefs<T extends Object>(
    Expression<T> Function($$RefuelsTableAnnotationComposer a) f,
  ) {
    final $$RefuelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.refuels,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RefuelsTableAnnotationComposer(
            $db: $db,
            $table: $db.refuels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> odometerReadingsRefs<T extends Object>(
    Expression<T> Function($$OdometerReadingsTableAnnotationComposer a) f,
  ) {
    final $$OdometerReadingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.odometerReadings,
      getReferencedColumn: (t) => t.vehicleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OdometerReadingsTableAnnotationComposer(
            $db: $db,
            $table: $db.odometerReadings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VehiclesTableTableManager
    extends
        RootTableManager<
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
          PrefetchHooks Function({bool refuelsRefs, bool odometerReadingsRefs})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<PropulsionType> propulsionType = const Value.absent(),
                Value<int> acquisitionDate = const Value.absent(),
                Value<int> initialMileage = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int?> sortOrder = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                name: name,
                propulsionType: propulsionType,
                acquisitionDate: acquisitionDate,
                initialMileage: initialMileage,
                isArchived: isArchived,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required PropulsionType propulsionType,
                required int acquisitionDate,
                Value<int> initialMileage = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int?> sortOrder = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                name: name,
                propulsionType: propulsionType,
                acquisitionDate: acquisitionDate,
                initialMileage: initialMileage,
                isArchived: isArchived,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VehiclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({refuelsRefs = false, odometerReadingsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (refuelsRefs) db.refuels,
                    if (odometerReadingsRefs) db.odometerReadings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (refuelsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          Refuel
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._refuelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).refuelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (odometerReadingsRefs)
                        await $_getPrefetchedData<
                          Vehicle,
                          $VehiclesTable,
                          OdometerReading
                        >(
                          currentTable: table,
                          referencedTable: $$VehiclesTableReferences
                              ._odometerReadingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VehiclesTableReferences(
                                db,
                                table,
                                p0,
                              ).odometerReadingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.vehicleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
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
      PrefetchHooks Function({bool refuelsRefs, bool odometerReadingsRefs})
    >;
typedef $$RefuelsTableCreateCompanionBuilder =
    RefuelsCompanion Function({
      Value<int> id,
      required int date,
      required int vehicleId,
      required double cost,
      required double amount,
      required FuelType fuelType,
      Value<bool> isFull,
      Value<int?> odometer,
      Value<String?> note,
    });
typedef $$RefuelsTableUpdateCompanionBuilder =
    RefuelsCompanion Function({
      Value<int> id,
      Value<int> date,
      Value<int> vehicleId,
      Value<double> cost,
      Value<double> amount,
      Value<FuelType> fuelType,
      Value<bool> isFull,
      Value<int?> odometer,
      Value<String?> note,
    });

final class $$RefuelsTableReferences
    extends BaseReferences<_$AppDatabase, $RefuelsTable, Refuel> {
  $$RefuelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('refuels__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RefuelsTableFilterComposer
    extends Composer<_$AppDatabase, $RefuelsTable> {
  $$RefuelsTableFilterComposer({
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

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FuelType, FuelType, String> get fuelType =>
      $composableBuilder(
        column: $table.fuelType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelsTableOrderingComposer
    extends Composer<_$AppDatabase, $RefuelsTable> {
  $$RefuelsTableOrderingComposer({
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

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fuelType => $composableBuilder(
    column: $table.fuelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFull => $composableBuilder(
    column: $table.isFull,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get odometer => $composableBuilder(
    column: $table.odometer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RefuelsTable> {
  $$RefuelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FuelType, String> get fuelType =>
      $composableBuilder(column: $table.fuelType, builder: (column) => column);

  GeneratedColumn<bool> get isFull =>
      $composableBuilder(column: $table.isFull, builder: (column) => column);

  GeneratedColumn<int> get odometer =>
      $composableBuilder(column: $table.odometer, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RefuelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RefuelsTable,
          Refuel,
          $$RefuelsTableFilterComposer,
          $$RefuelsTableOrderingComposer,
          $$RefuelsTableAnnotationComposer,
          $$RefuelsTableCreateCompanionBuilder,
          $$RefuelsTableUpdateCompanionBuilder,
          (Refuel, $$RefuelsTableReferences),
          Refuel,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$RefuelsTableTableManager(_$AppDatabase db, $RefuelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RefuelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RefuelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RefuelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<double> cost = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<FuelType> fuelType = const Value.absent(),
                Value<bool> isFull = const Value.absent(),
                Value<int?> odometer = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => RefuelsCompanion(
                id: id,
                date: date,
                vehicleId: vehicleId,
                cost: cost,
                amount: amount,
                fuelType: fuelType,
                isFull: isFull,
                odometer: odometer,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int date,
                required int vehicleId,
                required double cost,
                required double amount,
                required FuelType fuelType,
                Value<bool> isFull = const Value.absent(),
                Value<int?> odometer = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => RefuelsCompanion.insert(
                id: id,
                date: date,
                vehicleId: vehicleId,
                cost: cost,
                amount: amount,
                fuelType: fuelType,
                isFull: isFull,
                odometer: odometer,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RefuelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable: $$RefuelsTableReferences
                                    ._vehicleIdTable(db),
                                referencedColumn: $$RefuelsTableReferences
                                    ._vehicleIdTable(db)
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

typedef $$RefuelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RefuelsTable,
      Refuel,
      $$RefuelsTableFilterComposer,
      $$RefuelsTableOrderingComposer,
      $$RefuelsTableAnnotationComposer,
      $$RefuelsTableCreateCompanionBuilder,
      $$RefuelsTableUpdateCompanionBuilder,
      (Refuel, $$RefuelsTableReferences),
      Refuel,
      PrefetchHooks Function({bool vehicleId})
    >;
typedef $$OdometerReadingsTableCreateCompanionBuilder =
    OdometerReadingsCompanion Function({
      Value<int> id,
      required int date,
      required int vehicleId,
      required int value,
      Value<String?> note,
    });
typedef $$OdometerReadingsTableUpdateCompanionBuilder =
    OdometerReadingsCompanion Function({
      Value<int> id,
      Value<int> date,
      Value<int> vehicleId,
      Value<int> value,
      Value<String?> note,
    });

final class $$OdometerReadingsTableReferences
    extends
        BaseReferences<_$AppDatabase, $OdometerReadingsTable, OdometerReading> {
  $$OdometerReadingsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $VehiclesTable _vehicleIdTable(_$AppDatabase db) =>
      db.vehicles.createAlias('odometer_readings__vehicle_id__vehicles__id');

  $$VehiclesTableProcessedTableManager get vehicleId {
    final $_column = $_itemColumn<int>('vehicle_id')!;

    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vehicleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OdometerReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableFilterComposer({
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

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$VehiclesTableFilterComposer get vehicleId {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableOrderingComposer({
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

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$VehiclesTableOrderingComposer get vehicleId {
    final $$VehiclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableOrderingComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OdometerReadingsTable> {
  $$OdometerReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$VehiclesTableAnnotationComposer get vehicleId {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.vehicleId,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OdometerReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OdometerReadingsTable,
          OdometerReading,
          $$OdometerReadingsTableFilterComposer,
          $$OdometerReadingsTableOrderingComposer,
          $$OdometerReadingsTableAnnotationComposer,
          $$OdometerReadingsTableCreateCompanionBuilder,
          $$OdometerReadingsTableUpdateCompanionBuilder,
          (OdometerReading, $$OdometerReadingsTableReferences),
          OdometerReading,
          PrefetchHooks Function({bool vehicleId})
        > {
  $$OdometerReadingsTableTableManager(
    _$AppDatabase db,
    $OdometerReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OdometerReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OdometerReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OdometerReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> vehicleId = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => OdometerReadingsCompanion(
                id: id,
                date: date,
                vehicleId: vehicleId,
                value: value,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int date,
                required int vehicleId,
                required int value,
                Value<String?> note = const Value.absent(),
              }) => OdometerReadingsCompanion.insert(
                id: id,
                date: date,
                vehicleId: vehicleId,
                value: value,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OdometerReadingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({vehicleId = false}) {
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
                    if (vehicleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.vehicleId,
                                referencedTable:
                                    $$OdometerReadingsTableReferences
                                        ._vehicleIdTable(db),
                                referencedColumn:
                                    $$OdometerReadingsTableReferences
                                        ._vehicleIdTable(db)
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

typedef $$OdometerReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OdometerReadingsTable,
      OdometerReading,
      $$OdometerReadingsTableFilterComposer,
      $$OdometerReadingsTableOrderingComposer,
      $$OdometerReadingsTableAnnotationComposer,
      $$OdometerReadingsTableCreateCompanionBuilder,
      $$OdometerReadingsTableUpdateCompanionBuilder,
      (OdometerReading, $$OdometerReadingsTableReferences),
      OdometerReading,
      PrefetchHooks Function({bool vehicleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$RefuelsTableTableManager get refuels =>
      $$RefuelsTableTableManager(_db, _db.refuels);
  $$OdometerReadingsTableTableManager get odometerReadings =>
      $$OdometerReadingsTableTableManager(_db, _db.odometerReadings);
}
