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

/// AppBar title widget that shows the selected vehicle name as a dropdown.
///
/// - 0 vehicles: renders nothing
/// - 1 vehicle: renders just the name (no arrow, no tap)
/// - 2+ vehicles: renders name + arrow, opens a popup menu on tap
class AppBarVehicleSelector extends ConsumerWidget {
  const AppBarVehicleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? const [];
    if (vehicles.isEmpty) return const SizedBox.shrink();

    final selected = ref.watch(selectedVehicleProvider);
    final displayName = selected?.name ?? vehicles.first.name;
    final titleStyle = Theme.of(context).appBarTheme.titleTextStyle ??
        Theme.of(context).textTheme.titleLarge!;

    if (vehicles.length == 1) {
      return Text(displayName, style: titleStyle, overflow: TextOverflow.ellipsis);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) async {
        final overlay =
            Overlay.of(context).context.findRenderObject()! as RenderBox;
        final button = context.findRenderObject()! as RenderBox;
        final offset = button.localToGlobal(Offset.zero, ancestor: overlay);
        final position = RelativeRect.fromLTRB(
          offset.dx,
          offset.dy + button.size.height,
          overlay.size.width - offset.dx - button.size.width,
          0,
        );

        final chosen = await showMenu<int>(
          context: context,
          position: position,
          items: vehicles
              .map(
                (v) => PopupMenuItem<int>(
                  value: v.id,
                  child: Row(
                    children: [
                      if (v.id == selected?.id)
                        const Icon(Icons.check, size: 18, color: AppColors.accent)
                      else
                        const SizedBox(width: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          v.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
        if (chosen != null) {
          ref.read(selectedVehicleIdProvider.notifier).state = chosen;
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              displayName,
              style: titleStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Icon(Icons.arrow_drop_down, size: 22),
        ],
      ),
    );
  }
}
