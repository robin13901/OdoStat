import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:odostat/core/format/formatters.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/empty_state.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/liquid_glass_widgets.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_form_sheet.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fahrzeug löschen?'),
        content: Text(
          '„${vehicle.name}" und ALLE zugehörigen Tank-/Ladevorgänge und '
          'Kilometerstände werden dauerhaft gelöscht.',
        ),
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
    if (ok ?? false) {
      await ref.read(vehicleDaoProvider).deleteVehicle(vehicle.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          vehiclesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
            data: (vehicles) {
              if (vehicles.isEmpty) {
                return EmptyState(
                  icon: Icons.directions_car_rounded,
                  title: 'Noch keine Fahrzeuge',
                  subtitle: 'Lege dein erstes Fahrzeug an, um Tankvorgänge und '
                      'Kilometerstände zu erfassen.',
                  action: FilledButton.icon(
                    onPressed: () => VehicleFormSheet.show(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Fahrzeug anlegen'),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 76, 16, 120),
                itemCount: vehicles.length,
                itemBuilder: (context, i) => _VehicleCard(
                  vehicle: vehicles[i],
                  onEdit: () =>
                      VehicleFormSheet.show(context, existing: vehicles[i]),
                  onDelete: () => _confirmDelete(context, ref, vehicles[i]),
                ),
              );
            },
          ),
          buildLiquidGlassAppBar(context, title: const Text('Fahrzeuge'), showBackButton: false),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.onEdit,
    required this.onDelete,
  });

  final Vehicle vehicle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final electric = vehicle.propulsionType.isElectric;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onEdit,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.accent.withValues(alpha: 0.18),
            child: Icon(
              electric ? Icons.bolt_rounded : Icons.local_gas_station_rounded,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        vehicle.name,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (vehicle.isArchived) ...[
                      const SizedBox(width: 8),
                      const _Tag(label: 'Archiv'),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${vehicle.propulsionType.label} · seit '
                  '${Fmt.date(vehicle.acquisitionDate)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.onSurfaceMuted.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
