import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

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
