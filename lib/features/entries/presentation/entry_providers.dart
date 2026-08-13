import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

/// Which list the entries screen currently shows (refuels/charges vs. km).
///
/// Public so the shell can decide what the "+" FAB does on the entries tab.
enum EntryTab { refuels, odometer }

final entryTabProvider = StateProvider<EntryTab>((ref) => EntryTab.refuels);

/// Live refuels/charges of the currently selected vehicle (newest first).
final selectedVehicleRefuelsProvider = StreamProvider<List<Refuel>>((ref) {
  final vehicle = ref.watch(selectedVehicleProvider);
  if (vehicle == null) return Stream.value(const []);
  return ref.watch(refuelDaoProvider).watchForVehicle(vehicle.id);
});

/// Live odometer readings of the currently selected vehicle (newest first).
final selectedVehicleReadingsProvider =
    StreamProvider<List<OdometerReading>>((ref) {
  final vehicle = ref.watch(selectedVehicleProvider);
  if (vehicle == null) return Stream.value(const []);
  return ref.watch(odometerDaoProvider).watchForVehicle(vehicle.id);
});
