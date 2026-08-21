import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';

/// Live list of all vehicles (archived last).
final vehiclesProvider = StreamProvider<List<Vehicle>>((ref) {
  return ref.watch(vehicleDaoProvider).watchAll();
});

/// The currently selected vehicle id used across the app (dashboard, entries).
///
/// Defaults to the first non-archived vehicle once the list loads; kept in
/// sync by [selectedVehicleProvider].
final selectedVehicleIdProvider = StateProvider<int?>((ref) => null);

/// Watches the vehicle id that has the most recent entry (refuel or odometer).
///
/// Uses a UNION query across both tables, ordered by date desc then id desc,
/// and returns the vehicle_id of the single most recent row.
/// Emits null if no entries exist at all.
final latestEntryVehicleIdProvider = StreamProvider<int?>((ref) {
  final db = ref.watch(appDatabaseProvider);
  const sql = '''
    SELECT vehicle_id, date, id FROM refuels
    UNION ALL
    SELECT vehicle_id, date, id FROM odometer_readings
    ORDER BY date DESC, id DESC
    LIMIT 1
  ''';
  return db
      .customSelect(sql, readsFrom: {db.refuels, db.odometerReadings})
      .watch()
      .map((rows) => rows.isEmpty ? null : rows.first.read<int>('vehicle_id'));
});

/// The resolved selected [Vehicle], falling back to the vehicle with the most
/// recent entry, or the first vehicle if no entries exist.
///
/// Also repairs a stale selection (e.g. after the selected vehicle was
/// deleted) by falling back to the latest-entry vehicle or the first vehicle.
final selectedVehicleProvider = Provider<Vehicle?>((ref) {
  final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? const [];
  if (vehicles.isEmpty) return null;

  final selectedId = ref.watch(selectedVehicleIdProvider);
  if (selectedId != null) {
    final match = vehicles.where((v) => v.id == selectedId).firstOrNull;
    return match ?? vehicles.first;
  }

  // No explicit selection yet — use the vehicle with the most recent entry.
  final latestId = ref.watch(latestEntryVehicleIdProvider).valueOrNull;
  if (latestId != null) {
    final match = vehicles.where((v) => v.id == latestId).firstOrNull;
    if (match != null) return match;
  }

  return vehicles.first;
});
