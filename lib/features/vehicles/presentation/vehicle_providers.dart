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

/// The resolved selected [Vehicle], falling back to the first available one.
///
/// Also repairs a stale selection (e.g. after the selected vehicle was
/// deleted) by falling back to the first vehicle in the list.
final selectedVehicleProvider = Provider<Vehicle?>((ref) {
  final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? const [];
  if (vehicles.isEmpty) return null;

  final selectedId = ref.watch(selectedVehicleIdProvider);
  final match = vehicles.where((v) => v.id == selectedId).firstOrNull;
  return match ?? vehicles.first;
});
