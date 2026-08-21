import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/empty_state.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/liquid_glass_widgets.dart';
import 'package:odostat/core/widgets/vehicle_selector.dart';
import 'package:odostat/features/entries/presentation/entry_providers.dart';
import 'package:odostat/features/entries/presentation/odometer_form_sheet.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

class OdometerScreen extends ConsumerWidget {
  const OdometerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(selectedVehicleProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          if (vehicle == null)
            const EmptyState(
              icon: Icons.directions_car_rounded,
              title: 'Kein Fahrzeug',
              subtitle: 'Lege zuerst ein Fahrzeug an.',
            )
          else
            _OdometerList(vehicle: vehicle),
          buildLiquidGlassAppBar(
            context,
            title: const Text('Kilometer'),
            showBackButton: false,
            vehicleSelector: const AppBarVehicleSelector(),
          ),
        ],
      ),
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
