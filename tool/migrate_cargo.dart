// Standalone one-shot migration: CarGo (Room/SQLite) → OdoStat (Drift/SQLite).
//
// CarGo has no export feature, so its data lives only in the app's SQLite
// database file. Pull that file off the device, then run:
//
//   dart run tool/migrate_cargo.dart <cargo.db> [out.db]
//
// This produces a ready-to-open OdoStat database (default: odostat-import.db)
// which you import in OdoStat via  Einstellungen → Datensicherung → Importieren.
//
// Trips and Locations are intentionally dropped. All CarGo vehicles are
// treated as combustion (the only kind CarGo supports); switch a vehicle to
// electric later in the app if needed.
//
// Uses only package:sqlite3 — no Flutter, runs on the desktop Dart VM.

import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

/// OdoStat schema (drift schemaVersion 1). Kept in sync with the CREATE
/// statements drift generates for AppDatabase (verified 2026-08-13).
const List<String> _createStatements = [
  'CREATE TABLE "vehicles" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "name" TEXT NOT NULL UNIQUE, "propulsion_type" TEXT NOT NULL, "acquisition_date" INTEGER NOT NULL, "initial_mileage" INTEGER NOT NULL DEFAULT 0, "is_archived" INTEGER NOT NULL DEFAULT 0 CHECK ("is_archived" IN (0, 1)), "sort_order" INTEGER NULL)',
  'CREATE TABLE "refuels" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "date" INTEGER NOT NULL, "vehicle_id" INTEGER NOT NULL REFERENCES vehicles (id) ON DELETE CASCADE, "cost" REAL NOT NULL, "amount" REAL NOT NULL, "fuel_type" TEXT NOT NULL, "is_full" INTEGER NOT NULL DEFAULT 1 CHECK ("is_full" IN (0, 1)), "odometer" INTEGER NULL, "note" TEXT NULL)',
  'CREATE TABLE "odometer_readings" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, "date" INTEGER NOT NULL, "vehicle_id" INTEGER NOT NULL REFERENCES vehicles (id) ON DELETE CASCADE, "value" INTEGER NOT NULL, "note" TEXT NULL)',
];

/// OdoStat drift schemaVersion — must match AppDatabase.schemaVersion.
const int _schemaVersion = 1;

/// Maps CarGo's fuelType strings (E5/E10/Diesel) to OdoStat enum names.
String _mapFuelType(String cargo) => switch (cargo.trim().toUpperCase()) {
      'E5' => 'e5',
      'E10' => 'e10',
      'DIESEL' => 'diesel',
      _ => 'e10', // sensible default for unexpected values
    };

/// Rounds a float to 2 decimals (Room stored these as float → noisy doubles).
double _round2(num v) => (v * 100).round() / 100;

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/migrate_cargo.dart <cargo.db> [out.db]',
    );
    exit(64);
  }

  final sourcePath = args[0];
  final outPath = args.length > 1 ? args[1] : 'odostat-import.db';

  if (!File(sourcePath).existsSync()) {
    stderr.writeln('Source file not found: $sourcePath');
    exit(66);
  }
  if (File(outPath).existsSync()) {
    File(outPath).deleteSync();
    stdout.writeln('Removed existing $outPath');
  }

  final src = sqlite3.open(sourcePath, mode: OpenMode.readOnly);
  final out = sqlite3.open(outPath);

  try {
    // 1. Create the OdoStat schema.
    _createStatements.forEach(out.execute);
    out.execute('PRAGMA user_version = $_schemaVersion');

    // 2. Vehicles.
    final vehicles = src.select('SELECT * FROM Vehicles');
    final insVehicle = out.prepare(
      'INSERT INTO vehicles (id, name, propulsion_type, acquisition_date, '
      'initial_mileage, is_archived, sort_order) '
      'VALUES (?, ?, ?, ?, ?, 0, NULL)',
    );
    for (final v in vehicles) {
      insVehicle.execute([
        v['id'],
        v['name'],
        'combustion',
        v['acquisitionDate'],
        v['initialMileage'],
      ]);
    }
    insVehicle.close();

    // 3. Refuels → refuels (liters → amount, fuelType mapped, rounded).
    final refuels = src.select('SELECT * FROM Refuels');
    final insRefuel = out.prepare(
      'INSERT INTO refuels (id, date, vehicle_id, cost, amount, fuel_type, '
      'is_full, odometer, note) VALUES (?, ?, ?, ?, ?, ?, 1, NULL, NULL)',
    );
    for (final r in refuels) {
      insRefuel.execute([
        r['id'],
        r['date'],
        r['vehicleId'],
        _round2(r['cost'] as num),
        _round2(r['liters'] as num),
        _mapFuelType(r['fuelType'] as String),
      ]);
    }
    insRefuel.close();

    // 4. Mileages → odometer_readings.
    final mileages = src.select('SELECT * FROM Mileages');
    final insReading = out.prepare(
      'INSERT INTO odometer_readings (id, date, vehicle_id, value, note) '
      'VALUES (?, ?, ?, ?, NULL)',
    );
    for (final m in mileages) {
      insReading.execute([m['id'], m['date'], m['vehicleId'], m['value']]);
    }
    insReading.close();

    // 5. Report.
    stdout
      ..writeln('Migration complete → $outPath')
      ..writeln('  vehicles:          ${vehicles.length}')
      ..writeln('  refuels:           ${refuels.length}')
      ..writeln('  odometer_readings: ${mileages.length}')
      ..writeln()
      ..writeln('Import in OdoStat: Einstellungen → Datensicherung → '
          'Importieren.');
  } finally {
    src.close();
    out.close();
  }
}
