import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/enums.dart';

AppDatabase _memoryDb() =>
    AppDatabase.forExecutor(NativeDatabase.memory());

void main() {
  late AppDatabase db;

  setUp(() => db = _memoryDb());
  tearDown(() => db.close());

  test('insert + read a vehicle', () async {
    final id = await db.vehicleDao.insertVehicle(
      VehiclesCompanion.insert(
        name: 'Opel Astra',
        propulsionType: PropulsionType.combustion,
        acquisitionDate: 20210204,
        initialMileage: const Value(123100),
      ),
    );

    final v = await db.vehicleDao.getById(id);
    expect(v, isNotNull);
    expect(v!.name, 'Opel Astra');
    expect(v.propulsionType, PropulsionType.combustion);
    expect(v.initialMileage, 123100);
    expect(v.isArchived, isFalse);
  });

  test('refuels and readings cascade-delete with their vehicle', () async {
    final vid = await db.vehicleDao.insertVehicle(
      VehiclesCompanion.insert(
        name: 'Test',
        propulsionType: PropulsionType.combustion,
        acquisitionDate: 20200101,
      ),
    );

    await db.refuelDao.insertRefuel(
      RefuelsCompanion.insert(
        date: 20240101,
        vehicleId: vid,
        cost: 65.5,
        amount: 42,
        fuelType: FuelType.e10,
      ),
    );
    await db.odometerDao.insertReading(
      OdometerReadingsCompanion.insert(
        date: 20240101,
        vehicleId: vid,
        value: 130000,
      ),
    );

    expect((await db.refuelDao.getForVehicle(vid)).length, 1);
    expect((await db.odometerDao.getForVehicle(vid)).length, 1);

    await db.vehicleDao.deleteVehicle(vid);

    expect(await db.refuelDao.getForVehicle(vid), isEmpty);
    expect(await db.odometerDao.getForVehicle(vid), isEmpty);
  });

  test('latestForVehicle returns the newest reading', () async {
    final vid = await db.vehicleDao.insertVehicle(
      VehiclesCompanion.insert(
        name: 'Test',
        propulsionType: PropulsionType.electric,
        acquisitionDate: 20270101,
      ),
    );
    for (final (date, value) in [
      (20270101, 1000),
      (20270301, 5000),
      (20270201, 3000),
    ]) {
      await db.odometerDao.insertReading(
        OdometerReadingsCompanion.insert(
          date: date,
          vehicleId: vid,
          value: value,
        ),
      );
    }

    final latest = await db.odometerDao.latestForVehicle(vid);
    expect(latest!.value, 5000);
    expect(latest.date, 20270301);
  });
}
