import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/features/dashboard/domain/period_stats.dart';

/// One named series to plot over months 1..12.
class ChartSeries {
  const ChartSeries({
    required this.label,
    required this.color,
    required this.points,
  });

  final String label;
  final Color color;
  final List<MonthlyPoint> points;
}

/// A line chart plotting one or more [ChartSeries] across the 12 months.
///
/// Gaps (null values) break the line rather than dropping to zero, so a month
/// without data doesn't distort the trend.
class MonthlyLineChart extends StatelessWidget {
  const MonthlyLineChart({required this.series, super.key});

  final List<ChartSeries> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAny =
        series.any((s) => s.points.any((p) => p.value != null));
    if (!hasAny) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text('Keine Daten', style: theme.textTheme.bodySmall),
        ),
      );
    }

    final lineBarsData = [
      for (final s in series)
        LineChartBarData(
          spots: [
            for (final p in s.points)
              if (p.value != null) FlSpot(p.month.toDouble(), p.value!),
          ],
          isCurved: true,
          preventCurveOverShooting: true,
          color: s.color,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: series.length == 1,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                s.color.withValues(alpha: 0.25),
                s.color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
    ];

    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    for (final barData in lineBarsData) {
      for (final spot in barData.spots) {
        if (spot.y < minY) minY = spot.y;
        if (spot.y > maxY) maxY = spot.y;
      }
    }

    final padding = (maxY - minY) * 0.05;
    final chartMinY = minY - padding;
    final chartMaxY = maxY + padding;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minX: 1,
          maxX: 12,
          minY: chartMinY,
          maxY: chartMaxY,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: AppColors.hairline, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if ((value - meta.min).abs() < 0.001 ||
                      (value - meta.max).abs() < 0.001) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    value.toStringAsFixed(0),
                    style: theme.textTheme.labelSmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final m = value.round();
                  if (m < 1 || m > 12) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      Fmt.monthShort(m),
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: lineBarsData,
        ),
      ),
    );
  }
}
