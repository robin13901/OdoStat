@Tags(['migration'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/enums.dart';

/// Opens a database produced by tool/migrate_cargo.dart with the real
/// [AppDatabase] and checks the data is readable. Only runs when the fixture
/// path is provided via `--dart-define=MIGRATED_DB=<path>` (kept out of CI
/// because it needs a real migrated file). Verifies schema compatibility of
/// the migration tool against the live drift schema.
void main() {
  const path = String.fromEnvironment('MIGRATED_DB');

  test(
    'migrated CarGo db opens with AppDatabase and reads data',
    () async {
      final db = AppDatabase.forExecutor(NativeDatabase(File(path)));
      final vehicles = await db.vehicleDao.getAll();
      expect(vehicles, isNotEmpty);
      expect(vehicles.first.propulsionType, PropulsionType.combustion);

      final refuels = await db.refuelDao.getForVehicle(vehicles.first.id);
      expect(refuels, isNotEmpty);
      // Rounded to 2 decimals by the migration tool.
      for (final r in refuels.take(5)) {
        expect(r.cost, closeTo((r.cost * 100).round() / 100, 0.0001));
      }

      final readings =
          await db.odometerDao.getForVehicle(vehicles.first.id);
      expect(readings, isNotEmpty);

      await db.close();
    },
    skip: path.isEmpty ? 'set --dart-define=MIGRATED_DB=<path>' : false,
  );
}
