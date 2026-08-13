/// How a vehicle is powered. Drives the entry UI (litres vs. kWh) and which
/// consumption unit the dashboard shows (L/100km vs. kWh/100km).
enum PropulsionType {
  combustion,
  electric;

  bool get isElectric => this == PropulsionType.electric;

  String get label => switch (this) {
    PropulsionType.combustion => 'Verbrenner',
    PropulsionType.electric => 'Elektro',
  };
}

/// The fuel/energy kind of a single refuel/charge entry.
///
/// Combustion vehicles use [e5]/[e10]/[diesel]; electric vehicles use
/// [electric]. Stored as TEXT via a converter.
enum FuelType {
  e5,
  e10,
  diesel,
  electric;

  bool get isElectric => this == FuelType.electric;

  String get label => switch (this) {
    FuelType.e5 => 'E5',
    FuelType.e10 => 'E10',
    FuelType.diesel => 'Diesel',
    FuelType.electric => 'Strom',
  };

  /// Fuel types selectable for a given propulsion.
  static List<FuelType> forPropulsion(PropulsionType p) => p.isElectric
      ? const [FuelType.electric]
      : const [FuelType.e5, FuelType.e10, FuelType.diesel];
}
