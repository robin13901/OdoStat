import 'package:drift/drift.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/tables/odometer_readings_table.dart';

part 'odometer_dao.g.dart';

@DriftAccessor(tables: [OdometerReadings])
class OdometerDao extends DatabaseAccessor<AppDatabase>
    with _$OdometerDaoMixin {
  OdometerDao(super.attachedDatabase);

  /// All readings for a vehicle, newest first.
  Stream<List<OdometerReading>> watchForVehicle(int vehicleId) {
    return (select(odometerReadings)
          ..where((r) => r.vehicleId.equals(vehicleId))
          ..orderBy([
            (r) => OrderingTerm.desc(r.date),
            (r) => OrderingTerm.desc(r.value),
          ]))
        .watch();
  }

  Future<List<OdometerReading>> getForVehicle(int vehicleId) {
    return (select(odometerReadings)
          ..where((r) => r.vehicleId.equals(vehicleId))
          ..orderBy([(r) => OrderingTerm.asc(r.date)]))
        .get();
  }

  /// The most recent reading (by date, then value) for a vehicle.
  Future<OdometerReading?> latestForVehicle(int vehicleId) {
    return (select(odometerReadings)
          ..where((r) => r.vehicleId.equals(vehicleId))
          ..orderBy([
            (r) => OrderingTerm.desc(r.date),
            (r) => OrderingTerm.desc(r.value),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertReading(OdometerReadingsCompanion entry) =>
      into(odometerReadings).insert(entry);

  Future<bool> updateReading(OdometerReading entry) =>
      update(odometerReadings).replace(entry);

  Future<int> deleteReading(int id) =>
      (delete(odometerReadings)..where((r) => r.id.equals(id))).go();
}
