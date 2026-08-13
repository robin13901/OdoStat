import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odostat/core/widgets/glass_bottom_nav.dart';
import 'package:odostat/core/widgets/glass_fab.dart';
import 'package:odostat/core/widgets/gradient_background.dart';
import 'package:odostat/features/entries/presentation/entry_providers.dart';
import 'package:odostat/features/entries/presentation/odometer_form_sheet.dart';
import 'package:odostat/features/entries/presentation/refuel_form_sheet.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_form_sheet.dart';
import 'package:odostat/features/vehicles/presentation/vehicle_providers.dart';

/// The persistent shell: ember backdrop, the tab content, and a bottom row
/// with the glass nav pill plus a round glass "+" FAB.
///
/// The nav + FAB live here (not in the feature Scaffolds) so they sit
/// correctly over the backdrop and stay put across tab switches. The FAB's
/// action depends on the active tab:
///   * Analyse (0): no FAB.
///   * Einträge (1): add a refuel/charge or an odometer reading (per segment).
///   * Fahrzeuge (2): add a vehicle.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    GlassNavDestination(icon: Icons.insights_rounded, label: 'Analyse'),
    GlassNavDestination(
      icon: Icons.local_gas_station_rounded,
      label: 'Einträge',
    ),
    GlassNavDestination(icon: Icons.directions_car_rounded, label: 'Fahrzeuge'),
  ];

  VoidCallback? _fabAction(BuildContext context, WidgetRef ref) {
    final index = navigationShell.currentIndex;
    if (index == 2) {
      return () => unawaited(VehicleFormSheet.show(context));
    }
    if (index == 1) {
      final vehicle = ref.watch(selectedVehicleProvider);
      if (vehicle == null) return null;
      final tab = ref.watch(entryTabProvider);
      return () => unawaited(
        tab == EntryTab.refuels
            ? RefuelFormSheet.show(context, vehicle: vehicle)
            : OdometerFormSheet.show(context, vehicle: vehicle),
      );
    }
    return null; // dashboard
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final action = _fabAction(context, ref);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(child: navigationShell),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GlassBottomNav(
                          currentIndex: navigationShell.currentIndex,
                          destinations: _destinations,
                          onTap: (i) => navigationShell.goBranch(
                            i,
                            initialLocation: i == navigationShell.currentIndex,
                          ),
                        ),
                      ),
                      if (action != null) ...[
                        const SizedBox(width: 12),
                        GlassFab(
                          icon: Icons.add,
                          tooltip: 'Hinzufügen',
                          onPressed: action,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
