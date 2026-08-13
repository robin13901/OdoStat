import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/features/dashboard/domain/period_stats.dart';

/// A minimal refuel record for stats (decoupled from Drift row types).
typedef RefuelRecord = ({int date, double cost, double amount});

/// A minimal odometer record for stats.
typedef OdometerRecord = ({int date, int value});

/// Pure functions computing dashboard statistics from refuel + odometer data.
///
/// All dates are packed yyyyMMdd ints. Distance for a period comes from
/// odometer readings, with linear interpolation at period boundaries so a
/// month/year that has no reading exactly on its edge still gets a fair share
/// of the surrounding interval (mirrors CarGo's boundary handling, generalised).
class StatsCalculator {
  const StatsCalculator._();

  /// Distance (km) driven within [fromDate, toDate) (both packed yyyyMMdd),
  /// interpolated from [readings]. Returns 0 if fewer than two readings or no
  /// overlap.
  ///
  /// [readings] need not be sorted.
  static double distanceInRange(
    List<OdometerRecord> readings,
    int fromDate,
    int toDate,
  ) {
    if (readings.length < 2) return 0;
    final sorted = [...readings]..sort((a, b) => a.date.compareTo(b.date));

    final from = Fmt.intToDate(fromDate).millisecondsSinceEpoch.toDouble();
    final to = Fmt.intToDate(toDate).millisecondsSinceEpoch.toDouble();
    if (to <= from) return 0;

    double km = 0;
    for (var i = 0; i < sorted.length - 1; i++) {
      final aT = Fmt.intToDate(sorted[i].date).millisecondsSinceEpoch
          .toDouble();
      final bT = Fmt.intToDate(sorted[i + 1].date).millisecondsSinceEpoch
          .toDouble();
      if (bT <= aT) continue; // same-day or out-of-order duplicates
      final segKm = (sorted[i + 1].value - sorted[i].value).toDouble();
      if (segKm <= 0) continue;

      // Overlap of [aT,bT] with [from,to].
      final lo = aT > from ? aT : from;
      final hi = bT < to ? bT : to;
      if (hi <= lo) continue;

      final fraction = (hi - lo) / (bT - aT);
      km += segKm * fraction;
    }
    return km;
  }

  /// The first day of a month/year as packed yyyyMMdd.
  static int _periodStart(int year, int month) =>
      year * 10000 + (month == 0 ? 1 : month) * 100 + 1;

  /// The exclusive end (first day of the next period) as packed yyyyMMdd.
  static int _periodEnd(int year, int month) {
    if (month == 0) return (year + 1) * 10000 + 101; // next year
    if (month == 12) return (year + 1) * 10000 + 101;
    return year * 10000 + (month + 1) * 100 + 1;
  }

  /// Metrics for one period (month 1-12, or month 0 for the whole [year]).
  static PeriodStats periodStats({
    required int year,
    required int month,
    required List<RefuelRecord> refuels,
    required List<OdometerRecord> readings,
  }) {
    final start = _periodStart(year, month);
    final end = _periodEnd(year, month);

    final inPeriod =
        refuels.where((r) => r.date >= start && r.date < end).toList();

    final totalCost = inPeriod.fold<double>(0, (s, r) => s + r.cost);
    final totalAmount = inPeriod.fold<double>(0, (s, r) => s + r.amount);
    final avgUnitPrice =
        totalAmount > 0 ? totalCost / totalAmount : 0.0;
    final distance = distanceInRange(readings, start, end);

    return PeriodStats(
      year: year,
      month: month,
      refuelCount: inPeriod.length,
      totalCost: totalCost,
      totalAmount: totalAmount,
      distanceKm: distance,
      avgUnitPrice: avgUnitPrice,
    );
  }

  /// A 12-element monthly series (Jan..Dec) for the chosen [metric] in [year].
  static List<MonthlyPoint> monthlySeries({
    required int year,
    required List<RefuelRecord> refuels,
    required List<OdometerRecord> readings,
    required ChartMetric metric,
  }) {
    return List.generate(12, (i) {
      final month = i + 1;
      final s = periodStats(
        year: year,
        month: month,
        refuels: refuels,
        readings: readings,
      );
      final value = switch (metric) {
        ChartMetric.distance => s.distanceKm > 0 ? s.distanceKm : null,
        ChartMetric.consumption => s.consumptionPer100km,
        ChartMetric.cost => s.totalCost > 0 ? s.totalCost : null,
        ChartMetric.costPer100km => s.costPer100km,
      };
      return MonthlyPoint(month: month, value: value);
    });
  }

  /// Distinct years present across refuels + readings, descending.
  static List<int> availableYears(
    List<RefuelRecord> refuels,
    List<OdometerRecord> readings,
  ) {
    final years = <int>{
      ...refuels.map((r) => Fmt.yearOf(r.date)),
      ...readings.map((r) => Fmt.yearOf(r.date)),
    };
    final list = years.toList()..sort((a, b) => b.compareTo(a));
    return list;
  }
}

/// The metric shown by dashboard charts.
enum ChartMetric {
  distance,
  consumption,
  cost,
  costPer100km;

  String get label => switch (this) {
    ChartMetric.distance => 'Strecke',
    ChartMetric.consumption => 'Verbrauch',
    ChartMetric.cost => 'Kosten',
    ChartMetric.costPer100km => 'Kosten/100 km',
  };
}
