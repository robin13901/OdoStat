import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:odostat/core/db/converters/enum_converters.dart';
import 'package:odostat/core/db/daos/odometer_dao.dart';
import 'package:odostat/core/db/daos/refuel_dao.dart';
import 'package:odostat/core/db/daos/vehicle_dao.dart';
// Enum types are referenced by the generated companions (via the .map()
// converters), so they must be in scope for the part file to compile.
import 'package:odostat/core/db/enums.dart';
import 'package:odostat/core/db/tables/odometer_readings_table.dart';
import 'package:odostat/core/db/tables/refuels_table.dart';
import 'package:odostat/core/db/tables/vehicles_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Vehicles, Refuels, OdometerReadings],
  daos: [VehicleDao, RefuelDao, OdometerDao],
)
class AppDatabase extends _$AppDatabase {
  /// Opens the on-device database file.
  AppDatabase() : super(_openConnection());

  /// Test / migration constructor — inject an in-memory or file executor.
  AppDatabase.forExecutor(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    beforeOpen: (details) async {
      // Enforce foreign keys (cascade deletes of refuels/readings).
      await customStatement('PRAGMA foreign_keys = ON');
    },
    // Versioned onUpgrade steps go here when schemaVersion is bumped.
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'odostat');
  }
}
