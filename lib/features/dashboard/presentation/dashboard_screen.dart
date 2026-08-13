import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/empty_state.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/vehicle_selector.dart';
import 'package:odostat/features/dashboard/domain/period_stats.dart';
import 'package:odostat/features/dashboard/domain/stats_calculator.dart';
import 'package:odostat/features/dashboard/presentation/compare_screen.dart';
import 'package:odostat/features/dashboard/presentation/dashboard_providers.dart';
import 'package:odostat/features/dashboard/presentation/widgets/metric_tile.dart';
import 'package:odostat/features/dashboard/presentation/widgets/monthly_line_chart.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

final _selectedYearProvider = StateProvider<int?>((ref) => null);
final _chartMetricProvider =
    StateProvider<ChartMetric>((ref) => ChartMetric.distance);

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(selectedVehicleProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Analyse'),
        actions: [
          IconButton(
            tooltip: 'Vergleich',
            icon: const Icon(Icons.compare_arrows_rounded),
            onPressed: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<void>(builder: (_) => const CompareScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Einstellungen',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: vehicle == null
          ? EmptyState(
              icon: Icons.insights_rounded,
              title: 'Noch keine Daten',
              subtitle: 'Lege ein Fahrzeug an und erfasse Tankvorgänge und '
                  'Kilometerstände, um deine Analyse zu sehen.',
              action: FilledButton.icon(
                onPressed: () => context.go('/vehicles'),
                icon: const Icon(Icons.directions_car_rounded),
                label: const Text('Zu den Fahrzeugen'),
              ),
            )
          : _DashboardBody(vehicle: vehicle),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(vehicleStatsDataProvider(vehicle.id));
    final electric = vehicle.propulsionType.isElectric;

    return dataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (data) {
        final years = StatsCalculator.availableYears(
          data.refuels,
          data.readings,
        );
        if (years.isEmpty) {
          return const EmptyState(
            icon: Icons.insights_rounded,
            title: 'Keine Einträge',
            subtitle: 'Erfasse Tankvorgänge und Kilometerstände.',
          );
        }

        final selectedYear = ref.watch(_selectedYearProvider) ?? years.first;
        final year = years.contains(selectedYear) ? selectedYear : years.first;
        final metric = ref.watch(_chartMetricProvider);

        final yearStats = StatsCalculator.periodStats(
          year: year,
          month: 0,
          refuels: data.refuels,
          readings: data.readings,
        );
        final series = StatsCalculator.monthlySeries(
          year: year,
          refuels: data.refuels,
          readings: data.readings,
          metric: metric,
        );

        return ListView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 130),
          children: [
            const VehicleSelector(),
            const SizedBox(height: 12),
            _YearSelector(
              years: years,
              selected: year,
              onSelected: (y) =>
                  ref.read(_selectedYearProvider.notifier).state = y,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MetricGrid(stats: yearStats, electric: electric),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${metric.label} pro Monat · $year',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    MonthlyLineChart(
                      series: [
                        ChartSeries(
                          label: vehicle.name,
                          color: AppColors.accent,
                          points: series,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _MetricChips(
                      selected: metric,
                      onSelected: (m) =>
                          ref.read(_chartMetricProvider.notifier).state = m,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.stats, required this.electric});

  final PeriodStats stats;
  final bool electric;

  @override
  Widget build(BuildContext context) {
    final consumption = stats.consumptionPer100km;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        MetricTile(
          icon: Icons.route_rounded,
          label: 'Strecke',
          value: Fmt.km(stats.distanceKm),
        ),
        MetricTile(
          icon: electric ? Icons.bolt_rounded : Icons.speed_rounded,
          label: 'Ø Verbrauch',
          value: consumption == null
              ? '—'
              : Fmt.per100km(consumption, electric: electric),
        ),
        MetricTile(
          icon: Icons.euro_rounded,
          label: 'Kosten',
          value: Fmt.euro(stats.totalCost),
        ),
        MetricTile(
          icon: Icons.local_gas_station_rounded,
          label: electric ? 'Ø €/kWh' : 'Ø €/l',
          value: electric
              ? Fmt.eurPerKwh(stats.avgUnitPrice)
              : Fmt.eurPerLiter(stats.avgUnitPrice),
        ),
      ],
    );
  }
}

class _YearSelector extends StatelessWidget {
  const _YearSelector({
    required this.years,
    required this.selected,
    required this.onSelected,
  });

  final List<int> years;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: years.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final y = years[i];
          final isSel = y == selected;
          return ChoiceChip(
            label: Text('$y'),
            selected: isSel,
            onSelected: (_) => onSelected(y),
            selectedColor: AppColors.accent.withValues(alpha: 0.22),
            side: BorderSide(
              color: isSel ? AppColors.accent : AppColors.hairline,
            ),
          );
        },
      ),
    );
  }
}

class _MetricChips extends StatelessWidget {
  const _MetricChips({required this.selected, required this.onSelected});

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
