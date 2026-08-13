import 'package:drift/drift.dart';
import 'package:odostat/core/db/enums.dart';

/// Stores [PropulsionType] as its enum name (TEXT).
class PropulsionTypeConverter extends TypeConverter<PropulsionType, String> {
  const PropulsionTypeConverter();

  @override
  PropulsionType fromSql(String fromDb) =>
      PropulsionType.values.byName(fromDb);

  @override
  String toSql(PropulsionType value) => value.name;
}

/// Stores [FuelType] as its enum name (TEXT).
class FuelTypeConverter extends TypeConverter<FuelType, String> {
  const FuelTypeConverter();

  @override
  FuelType fromSql(String fromDb) => FuelType.values.byName(fromDb);

  @override
  String toSql(FuelType value) => value.name;
}
