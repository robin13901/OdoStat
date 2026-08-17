import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/empty_state.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/gradient_background.dart';
import 'package:odostat/core/widgets/liquid_glass_widgets.dart';
import 'package:odostat/features/dashboard/domain/stats_calculator.dart';
import 'package:odostat/features/dashboard/presentation/dashboard_providers.dart';
import 'package:odostat/features/dashboard/presentation/widgets/monthly_line_chart.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

/// One side of the comparison: which vehicle + which year.
typedef CompareSelection = ({int? vehicleId, int? year});

final _selectionAProvider =
    StateProvider<CompareSelection>((ref) => (vehicleId: null, year: null));
final _selectionBProvider =
    StateProvider<CompareSelection>((ref) => (vehicleId: null, year: null));
final _compareMetricProvider =
    StateProvider<ChartMetric>((ref) => ChartMetric.distance);

/// Compares two (vehicle, year) selections on the same 12-month axis.
///
/// Enables the flagship use case: Opel 2026 vs. electric car 2027 — distance /
/// consumption / cost overlaid month-by-month.
class CompareScreen extends ConsumerWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? const [];

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (vehicles.isEmpty)
              const EmptyState(
                icon: Icons.compare_arrows_rounded,
                title: 'Nichts zu vergleichen',
                subtitle: 'Lege Fahrzeuge an und erfasse Daten.',
              )
            else
              _CompareBody(vehicles: vehicles),
            buildLiquidGlassAppBar(context, title: const Text('Vergleich')),
          ],
        ),
      ),
    );
  }
}

class _CompareBody extends ConsumerWidget {
  const _CompareBody({required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selA = ref.watch(_selectionAProvider);
    final selB = ref.watch(_selectionBProvider);
    final metric = ref.watch(_compareMetricProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
      children: [
        _SelectionCard(
          title: 'A',
          color: AppColors.accent,
          vehicles: vehicles,
          selection: selA,
          onChanged: (s) => ref.read(_selectionAProvider.notifier).state = s,
        ),
        const SizedBox(height: 12),
        _SelectionCard(
          title: 'B',
          color: AppColors.accentContrast,
          vehicles: vehicles,
          selection: selB,
          onChanged: (s) => ref.read(_selectionBProvider.notifier).state = s,
        ),
        const SizedBox(height: 16),
        _MetricSelector(
          selected: metric,
          onSelected: (m) =>
              ref.read(_compareMetricProvider.notifier).state = m,
        ),
        const SizedBox(height: 16),
        _CompareChart(
          vehicles: vehicles,
          selA: selA,
          selB: selB,
          metric: metric,
        ),
      ],
    );
  }
}

class _CompareChart extends ConsumerWidget {
  const _CompareChart({
    required this.vehicles,
    required this.selA,
    required this.selB,
    required this.metric,
  });

  final List<Vehicle> vehicles;
  final CompareSelection selA;
  final CompareSelection selB;
  final ChartMetric metric;

  Vehicle? _vehicle(int? id) =>
      vehicles.where((v) => v.id == id).firstOrNull;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vA = _vehicle(selA.vehicleId);
    final vB = _vehicle(selB.vehicleId);

    if ((vA == null || selA.year == null) &&
        (vB == null || selB.year == null)) {
      return const GlassCard(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Wähle oben Fahrzeug und Jahr für A und B.')),
      );
    }

    // Warn when comparing consumption across different propulsion units.
    final unitMismatch = vA != null &&
        vB != null &&
        vA.propulsionType.isElectric != vB.propulsionType.isElectric &&
        (metric == ChartMetric.consumption);

    final seriesList = <ChartSeries>[];
    for (final (sel, vehicle, color) in [
      (selA, vA, AppColors.accent),
      (selB, vB, AppColors.accentContrast),
    ]) {
      if (vehicle == null || sel.year == null) continue;
      final dataAsync = ref.watch(vehicleStatsDataProvider(vehicle.id));
      final data = dataAsync.valueOrNull;
      if (data == null) continue;
      seriesList.add(
        ChartSeries(
          label: '${vehicle.name} ${sel.year}',
          color: color,
          points: StatsCalculator.monthlySeries(
            year: sel.year!,
            refuels: data.refuels,
            readings: data.readings,
            metric: metric,
          ),
        ),
      );
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${metric.label} pro Monat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          MonthlyLineChart(series: seriesList),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              for (final s in seriesList) _LegendDot(series: s),
            ],
          ),
          if (unitMismatch) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verbrenner (l/100 km) und Elektro (kWh/100 km) sind nicht '
                    'direkt vergleichbar. Für einen fairen Vergleich '
                    '„Kosten/100 km" oder „Strecke" wählen.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.series});

  final ChartSeries series;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: series.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(series.label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _SelectionCard extends ConsumerWidget {
  const _SelectionCard({
    required this.title,
    required this.color,
    required this.vehicles,
    required this.selection,
    required this.onChanged,
  });

  final String title;
  final Color color;
  final List<Vehicle> vehicles;
  final CompareSelection selection;
  final ValueChanged<CompareSelection> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle =
        vehicles.where((v) => v.id == selection.vehicleId).firstOrNull;

    // Years available for the currently chosen vehicle.
    final years = vehicle == null
        ? <int>[]
        : (ref.watch(vehicleStatsDataProvider(vehicle.id)).valueOrNull == null
            ? <int>[]
            : StatsCalculator.availableYears(
                ref.watch(vehicleStatsDataProvider(vehicle.id)).value!.refuels,
                ref.watch(vehicleStatsDataProvider(vehicle.id)).value!.readings,
              ));

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text('Reihe $title',
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: selection.vehicleId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Fahrzeug'),
                  items: [
                    for (final v in vehicles)
                      DropdownMenuItem(value: v.id, child: Text(v.name)),
                  ],
                  onChanged: (id) =>
                      onChanged((vehicleId: id, year: null)),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 110,
                child: DropdownButtonFormField<int>(
                  initialValue:
                      years.contains(selection.year) ? selection.year : null,
                  decoration: const InputDecoration(labelText: 'Jahr'),
                  items: [
                    for (final y in years)
                      DropdownMenuItem(value: y, child: Text('$y')),
                  ],
                  onChanged: (y) => onChanged(
                    (vehicleId: selection.vehicleId, year: y),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricSelector extends StatelessWidget {
  const _MetricSelector({required this.selected, required this.onSelected});

  final ChartMetric selected;
  final ValueChanged<ChartMetric> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        for (final m in ChartMetric.values)
          ChoiceChip(
            label: Text(m.label),
            selected: m == selected,
            onSelected: (_) => onSelected(m),
            selectedColor: AppColors.accent.withValues(alpha: 0.22),
            side: BorderSide(
              color: m == selected ? AppColors.accent : AppColors.hairline,
            ),
          ),
      ],
    );
  }
}
