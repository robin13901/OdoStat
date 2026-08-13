import 'package:drift/drift.dart';
import 'package:odostat/core/db/converters/enum_converters.dart';
import 'package:odostat/core/db/tables/vehicles_table.dart';

/// A refuel (combustion) or charge (electric) event.
///
/// [amount] is litres for combustion vehicles and kWh for electric ones — the
/// unit is derived from the owning vehicle's propulsion type. Mirrors CarGo's
/// `Refuels` table (cost + liters + fuelType) generalised for electricity.
class Refuels extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Date packed as yyyyMMdd.
  IntColumn get date => integer()();

  IntColumn get vehicleId =>
      integer().references(Vehicles, #id, onDelete: KeyAction.cascade)();

  /// Total price paid, in euro.
  RealColumn get cost => real()();

  /// Litres (combustion) or kWh (electric).
  RealColumn get amount => real()();

  TextColumn get fuelType => text().map(const FuelTypeConverter())();

  /// Whether the tank/battery was filled completely (enables accurate
  /// full-to-full consumption). Defaults to true.
  BoolColumn get isFull => boolean().withDefault(const Constant(true))();

  /// Optional odometer reading at the time of refuelling (km).
  IntColumn get odometer => integer().nullable()();

  TextColumn get note => text().nullable()();
}
