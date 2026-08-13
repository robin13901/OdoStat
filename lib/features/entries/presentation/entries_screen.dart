import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/empty_state.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/vehicle_selector.dart';
import 'package:odostat/features/entries/presentation/entry_providers.dart';
import 'package:odostat/features/entries/presentation/odometer_form_sheet.dart';
import 'package:odostat/features/entries/presentation/refuel_form_sheet.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

/// Which list the entries screen currently shows.
enum EntryTab { refuels, odometer }

final _entryTabProvider = StateProvider<EntryTab>((ref) => EntryTab.refuels);

class EntriesScreen extends ConsumerWidget {
  const EntriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(selectedVehicleProvider);
    final tab = ref.watch(_entryTabProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Einträge')),
      floatingActionButton: vehicle == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (tab == EntryTab.refuels) {
                  unawaited(RefuelFormSheet.show(context, vehicle: vehicle));
                } else {
                  unawaited(OdometerFormSheet.show(context, vehicle: vehicle));
                }
              },
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              icon: const Icon(Icons.add),
              label: Text(tab == EntryTab.refuels
                  ? (vehicle.propulsionType.isElectric ? 'Laden' : 'Tanken')
                  : 'km-Stand'),
            ),
      body: vehicle == null
          ? const EmptyState(
              icon: Icons.directions_car_rounded,
              title: 'Kein Fahrzeug',
              subtitle: 'Lege zuerst ein Fahrzeug an.',
            )
          : Column(
              children: [
                const SizedBox(height: 8),
                const VehicleSelector(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SegmentedButton<EntryTab>(
                    segments: [
                      ButtonSegment(
                        value: EntryTab.refuels,
                        label: Text(
                          vehicle.propulsionType.isElectric
                              ? 'Laden'
                              : 'Tanken',
                        ),
                        icon: const Icon(Icons.local_gas_station_rounded),
                      ),
                      const ButtonSegment(
                        value: EntryTab.odometer,
                        label: Text('Kilometer'),
                        icon: Icon(Icons.speed_rounded),
                      ),
                    ],
                    selected: {tab},
                    onSelectionChanged: (s) =>
                        ref.read(_entryTabProvider.notifier).state = s.first,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: tab == EntryTab.refuels
                      ? _RefuelList(vehicle: vehicle)
                      : _OdometerList(vehicle: vehicle),
                ),
              ],
            ),
    );
  }
}

class _RefuelList extends ConsumerWidget {
  const _RefuelList({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(selectedVehicleRefuelsProvider);
    final electric = vehicle.propulsionType.isElectric;

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (items) {
        if (items.isEmpty) {
          return EmptyState(
            icon: electric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
            title: electric ? 'Keine Ladevorgänge' : 'Keine Tankvorgänge',
            subtitle: 'Tippe auf +, um den ersten Eintrag zu erfassen.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final r = items[i];
            final unitPrice = r.amount > 0 ? r.cost / r.amount : 0.0;
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              onTap: () => RefuelFormSheet.show(
                context,
                vehicle: vehicle,
                existing: r,
              ),
              onLongPress: () => _confirmDelete(
                context,
                onConfirm: () =>
                    ref.read(refuelDaoProvider).deleteRefuel(r.id),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Fmt.date(r.date),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${electric ? Fmt.kwh(r.amount) : Fmt.liters(r.amount)}'
                          ' · ${r.fuelType.label}'
                          '${r.isFull ? '' : ' · Teil'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Fmt.euro(r.cost),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        electric
                            ? Fmt.eurPerKwh(unitPrice)
                            : Fmt.eurPerLiter(unitPrice),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _OdometerList extends ConsumerWidget {
  const _OdometerList({required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(selectedVehicleReadingsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (items) {
        if (items.isEmpty) {
          return const EmptyState(
            icon: Icons.speed_rounded,
            title: 'Keine Kilometerstände',
            subtitle: 'Tippe auf +, um einen Kilometerstand zu erfassen.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final o = items[i];
            // Distance since the previous (older) reading, if any.
            final prev = i + 1 < items.length ? items[i + 1] : null;
            final delta = prev != null ? o.value - prev.value : null;
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              onTap: () => OdometerFormSheet.show(
                context,
                vehicle: vehicle,
                existing: o,
              ),
              onLongPress: () => _confirmDelete(
                context,
                onConfirm: () =>
                    ref.read(odometerDaoProvider).deleteReading(o.id),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Fmt.km(o.value),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Fmt.date(o.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (delta != null)
                    Text(
                      '+${Fmt.km(delta)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context, {
  required Future<void> Function() onConfirm,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eintrag löschen?'),
      content: const Text('Dieser Eintrag wird dauerhaft gelöscht.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Löschen'),
        ),
      ],
    ),
  );
  if (ok ?? false) await onConfirm();
}
