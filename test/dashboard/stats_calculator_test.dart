import 'package:flutter_test/flutter_test.dart';
import 'package:odostat/features/dashboard/domain/stats_calculator.dart';

void main() {
  group('distanceInRange', () {
    test('returns 0 with fewer than two readings', () {
      expect(
        StatsCalculator.distanceInRange(
          [(date: 20250101, value: 1000)],
          20250101,
          20260101,
        ),
        0,
      );
    });

    test('sums full distance when range covers all readings', () {
      final readings = <OdometerRecord>[
        (date: 20250101, value: 1000),
        (date: 20250201, value: 2000),
        (date: 20250301, value: 3500),
      ];
      // 1000 + 1500 = 2500 km over the whole span.
      expect(
        StatsCalculator.distanceInRange(readings, 20250101, 20250301),
        closeTo(2500, 0.001),
      );
    });

    test('interpolates a mid-month boundary linearly', () {
      // 3000 km over Jan (31 days). A range covering the first ~half should
      // yield roughly half.
      final readings = <OdometerRecord>[
        (date: 20250101, value: 0),
        (date: 20250201, value: 3100), // ~100 km/day over 31 days
      ];
      // Range Jan 1 → Jan 16 = 15 days of 31 → 15/31 * 3100 = 1500.
      final d = StatsCalculator.distanceInRange(readings, 20250101, 20250116);
      expect(d, closeTo(3100 * 15 / 31, 0.5));
    });

    test('ignores negative/zero segments (odometer reset or duplicate)', () {
      final readings = <OdometerRecord>[
        (date: 20250101, value: 5000),
        (date: 20250201, value: 4000), // went down — ignore
        (date: 20250301, value: 6000), // +2000 from the 4000
      ];
      expect(
        StatsCalculator.distanceInRange(readings, 20250101, 20250301),
        closeTo(2000, 0.001),
      );
    });
  });

  group('periodStats', () {
    final refuels = <RefuelRecord>[
      (date: 20250110, cost: 60, amount: 40),
      (date: 20250220, cost: 30, amount: 20),
      (date: 20260101, cost: 99, amount: 50), // different year
    ];
    final readings = <OdometerRecord>[
      (date: 20250101, value: 10000),
      (date: 20260101, value: 22000), // 12000 km across 2025
    ];

    test('yearly stats aggregate only that year', () {
      final s = StatsCalculator.periodStats(
        year: 2025,
        month: 0,
        refuels: refuels,
        readings: readings,
      );
      expect(s.isYear, isTrue);
      expect(s.refuelCount, 2);
      expect(s.totalCost, closeTo(90, 0.001));
      expect(s.totalAmount, closeTo(60, 0.001));
      expect(s.avgUnitPrice, closeTo(90 / 60, 0.001));
      expect(s.distanceKm, closeTo(12000, 1));
    });

    test('consumption per 100km = amount / distance * 100', () {
      final s = StatsCalculator.periodStats(
        year: 2025,
        month: 0,
        refuels: refuels,
        readings: readings,
      );
      // 60 L over 12000 km = 0.5 L/100km.
      expect(s.consumptionPer100km, closeTo(60 / 12000 * 100, 0.001));
      expect(s.costPer100km, closeTo(90 / 12000 * 100, 0.001));
    });

    test('monthly stats isolate a single month', () {
      final jan = StatsCalculator.periodStats(
        year: 2025,
        month: 1,
        refuels: refuels,
        readings: readings,
      );
      expect(jan.refuelCount, 1);
      expect(jan.totalCost, closeTo(60, 0.001));
    });
  });

  group('monthlySeries & availableYears', () {
    test('monthlySeries has 12 points with gaps as null', () {
      final series = StatsCalculator.monthlySeries(
        year: 2025,
        refuels: [(date: 20250315, cost: 50, amount: 30)],
        readings: const [],
        metric: ChartMetric.cost,
      );
      expect(series.length, 12);
      expect(series[2].value, closeTo(50, 0.001)); // March
      expect(series[0].value, isNull); // January empty
    });

    test('availableYears is the distinct set, descending', () {
      final years = StatsCalculator.availableYears(
        [(date: 20240101, cost: 1, amount: 1), (date: 20260101, cost: 1, amount: 1)],
        [(date: 20250101, value: 1)],
      );
      expect(years, [2026, 2025, 2024]);
    });
  });
}
