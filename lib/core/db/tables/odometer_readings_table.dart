import 'package:drift/drift.dart';
import 'package:odostat/core/db/tables/vehicles_table.dart';

/// A standalone odometer reading (km) on a given date.
///
/// Mirrors CarGo's `Mileages` table. Distances driven per period are derived
/// from the differences between these readings.
class OdometerReadings extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Date packed as yyyyMMdd.
  IntColumn get date => integer()();

  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();

  /// Odometer value in kilometres.
  IntColumn get value => integer()();

  TextColumn get note => text().nullable()();
}
