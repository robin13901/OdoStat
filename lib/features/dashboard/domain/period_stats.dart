/// Aggregated metrics for a single period (a month or a whole year).
class PeriodStats {
  const PeriodStats({
    required this.year,
    required this.month,
    required this.refuelCount,
    required this.totalCost,
    required this.totalAmount,
    required this.distanceKm,
    required this.avgUnitPrice,
  });

  /// Calendar year this period belongs to.
  final int year;

  /// Month 1-12, or 0 when this stat represents a whole year.
  final int month;

  final int refuelCount;

  /// Sum of costs in this period (€).
  final double totalCost;

  /// Sum of refuelled/charged amounts (litres or kWh).
  final double totalAmount;

  /// Distance driven in this period (km), derived from odometer readings.
  final double distanceKm;

  /// Average unit price (€/l or €/kWh) across refuels in the period.
  final double avgUnitPrice;

  bool get isYear => month == 0;

  /// Consumption per 100 km (l/100km or kWh/100km); null if no distance.
  double? get consumptionPer100km =>
      distanceKm > 0 ? totalAmount / distanceKm * 100 : null;

  /// Cost per 100 km (€/100km); null if no distance.
  double? get costPer100km =>
      distanceKm > 0 ? totalCost / distanceKm * 100 : null;
}

/// A single point in a monthly time series (used by charts).
class MonthlyPoint {
  const MonthlyPoint({required this.month, required this.value});

  /// Month 1-12.
  final int month;

  /// The metric value for this month (null = no data → gap in the line).
  final double? value;
}
