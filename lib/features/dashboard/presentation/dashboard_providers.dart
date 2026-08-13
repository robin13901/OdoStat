import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/features/dashboard/domain/stats_calculator.dart';

/// Bundle of a vehicle's refuel + odometer records for the calculator.
typedef VehicleStatsData = ({
  List<RefuelRecord> refuels,
  List<OdometerRecord> readings,
});

/// Live refuel + odometer records for a vehicle, mapped to the calculator's
/// lightweight record types. Re-emits whenever the vehicle's refuels or
/// readings change.
final StreamProviderFamily<VehicleStatsData, int> vehicleStatsDataProvider =
    StreamProvider.family<VehicleStatsData, int>((ref, vehicleId) {
  final refuelDao = ref.watch(refuelDaoProvider);
  final odoDao = ref.watch(odometerDaoProvider);

  final refuelStream = refuelDao.watchForVehicle(vehicleId);
  // Combine both streams: emit whenever either updates.
  return refuelStream.asyncMap((refuels) async {
    final readings = await odoDao.getForVehicle(vehicleId);
    return (
      refuels: [
        for (final r in refuels)
          (date: r.date, cost: r.cost, amount: r.amount),
      ],
      readings: [
        for (final o in readings) (date: o.date, value: o.value),
      ],
    );
  });
});
