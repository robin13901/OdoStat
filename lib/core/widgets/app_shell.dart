import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:odostat/core/widgets/glass_bottom_nav.dart';
import 'package:odostat/core/widgets/glass_fab.dart';
import 'package:odostat/core/widgets/gradient_background.dart';
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
///   * Tanken (1): add a refuel/charge entry.
///   * Kilometer (2): add an odometer reading.
///   * Fahrzeuge (3): add a vehicle.
class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    GlassNavDestination(icon: Icons.insights_rounded, label: 'Analyse'),
    GlassNavDestination(icon: Icons.local_gas_station_rounded, label: 'Tanken'),
    GlassNavDestination(icon: Icons.speed_rounded, label: 'Kilometer'),
    GlassNavDestination(icon: Icons.directions_car_rounded, label: 'Fahrzeuge'),
  ];

  VoidCallback? _fabAction(BuildContext context, WidgetRef ref) {
    final index = navigationShell.currentIndex;
    final vehicle = ref.watch(selectedVehicleProvider);
    if (index == 3) return () => unawaited(VehicleFormSheet.show(context));
    if (index == 1 && vehicle != null) {
      return () => unawaited(RefuelFormSheet.show(context, vehicle: vehicle));
    }
    if (index == 2 && vehicle != null) {
      return () => unawaited(OdometerFormSheet.show(context, vehicle: vehicle));
    }
    return null;
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
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
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
