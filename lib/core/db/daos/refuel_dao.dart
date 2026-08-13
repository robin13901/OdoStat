import 'package:drift/drift.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/tables/refuels_table.dart';

part 'refuel_dao.g.dart';

@DriftAccessor(tables: [Refuels])
class RefuelDao extends DatabaseAccessor<AppDatabase> with _$RefuelDaoMixin {
  RefuelDao(super.attachedDatabase);

  /// All refuels for a vehicle, newest first.
  Stream<List<Refuel>> watchForVehicle(int vehicleId) {
    return (select(refuels)
          ..where((r) => r.vehicleId.equals(vehicleId))
          ..orderBy([
            (r) => OrderingTerm.desc(r.date),
            (r) => OrderingTerm.desc(r.id),
          ]))
        .watch();
  }

  Future<List<Refuel>> getForVehicle(int vehicleId) {
    return (select(refuels)
          ..where((r) => r.vehicleId.equals(vehicleId))
          ..orderBy([(r) => OrderingTerm.asc(r.date)]))
        .get();
  }

  Future<int> insertRefuel(RefuelsCompanion entry) =>
      into(refuels).insert(entry);

  Future<bool> updateRefuel(Refuel entry) => update(refuels).replace(entry);

  Future<int> deleteRefuel(int id) =>
      (delete(refuels)..where((r) => r.id.equals(id))).go();
}
