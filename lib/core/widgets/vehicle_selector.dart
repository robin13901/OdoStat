import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

/// Horizontal chip row to pick the active vehicle. Shared by the entries and
/// dashboard screens; reads/writes [selectedVehicleIdProvider].
///
/// Renders nothing when there are fewer than two vehicles (no choice to make).
class VehicleSelector extends ConsumerWidget {
  const VehicleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? const [];
    if (vehicles.length < 2) return const SizedBox.shrink();

    final selected = ref.watch(selectedVehicleProvider);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: vehicles.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final v = vehicles[i];
          final isSelected = v.id == selected?.id;
          return ChoiceChip(
            label: Text(v.name),
            selected: isSelected,
            onSelected: (_) =>
                ref.read(selectedVehicleIdProvider.notifier).state = v.id,
            selectedColor: AppColors.accent.withValues(alpha: 0.22),
            side: BorderSide(
              color: isSelected ? AppColors.accent : AppColors.hairline,
            ),
          );
        },
      ),
    );
  }
}
