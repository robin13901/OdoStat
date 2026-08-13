// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'odometer_dao.dart';

// ignore_for_file: type=lint
mixin _$OdometerDaoMixin on DatabaseAccessor<AppDatabase> {
  $VehiclesTable get vehicles => attachedDatabase.vehicles;
  $OdometerReadingsTable get odometerReadings =>
      attachedDatabase.odometerReadings;
  OdometerDaoManager get managers => OdometerDaoManager(this);
}

class OdometerDaoManager {
  final _$OdometerDaoMixin _db;
  OdometerDaoManager(this._db);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db.attachedDatabase, _db.vehicles);
  $$OdometerReadingsTableTableManager get odometerReadings =>
      $$OdometerReadingsTableTableManager(
        _db.attachedDatabase,
        _db.odometerReadings,
      );
}
