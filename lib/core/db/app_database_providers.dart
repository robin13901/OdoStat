import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/daos/odometer_dao.dart';
import 'package:odostat/core/db/daos/refuel_dao.dart';
import 'package:odostat/core/db/daos/vehicle_dao.dart';

/// The single app-wide [AppDatabase] instance.
///
/// Kept alive for the app's lifetime; closed when the provider is disposed
/// (e.g. after a backup restore rebuilds it).
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final vehicleDaoProvider = Provider<VehicleDao>(
  (ref) => ref.watch(appDatabaseProvider).vehicleDao,
);

final refuelDaoProvider = Provider<RefuelDao>(
  (ref) => ref.watch(appDatabaseProvider).refuelDao,
);

final odometerDaoProvider = Provider<OdometerDao>(
  (ref) => ref.watch(appDatabaseProvider).odometerDao,
);
