import 'package:drift/drift.dart';
import 'package:odostat/core/db/converters/enum_converters.dart';

/// A vehicle the user tracks (car, scooter, …).
///
/// Mirrors CarGo's `Vehicles` table plus a [propulsionType] to support
/// electric vehicles, and an [isArchived] flag to hide retired vehicles.
class Vehicles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 80).unique()();
  TextColumn get propulsionType =>
      text().map(const PropulsionTypeConverter())();

  /// Acquisition date, packed as yyyyMMdd (CarGo convention).
  IntColumn get acquisitionDate => integer()();

  /// Odometer reading when the vehicle was acquired (km).
  IntColumn get initialMileage => integer().withDefault(const Constant(0))();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().nullable()();
}
