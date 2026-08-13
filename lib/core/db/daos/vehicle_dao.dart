import 'package:drift/drift.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/tables/vehicles_table.dart';

part 'vehicle_dao.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehicleDao extends DatabaseAccessor<AppDatabase>
    with _$VehicleDaoMixin {
  VehicleDao(super.attachedDatabase);

  /// All vehicles, archived last, then by sortOrder / name.
  Stream<List<Vehicle>> watchAll() {
    return (select(vehicles)
          ..orderBy([
            (v) => OrderingTerm.asc(v.isArchived),
            (v) => OrderingTerm.asc(v.sortOrder),
            (v) => OrderingTerm.asc(v.name),
          ]))
        .watch();
  }

  Future<List<Vehicle>> getAll() => select(vehicles).get();

  Future<Vehicle?> getById(int id) =>
      (select(vehicles)..where((v) => v.id.equals(id))).getSingleOrNull();

  Future<int> insertVehicle(VehiclesCompanion entry) =>
      into(vehicles).insert(entry);

  Future<bool> updateVehicle(Vehicle entry) => update(vehicles).replace(entry);

  Future<int> deleteVehicle(int id) =>
      (delete(vehicles)..where((v) => v.id.equals(id))).go();
}
