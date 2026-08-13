import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odostat/core/widgets/glass_bottom_nav.dart';
import 'package:odostat/core/widgets/gradient_background.dart';

/// The persistent shell: ember backdrop + a floating glass bottom nav that
/// switches between the three main branches. Settings is reachable from the
/// dashboard app bar, not the nav (kept out of the pill).
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    GlassNavDestination(icon: Icons.insights_rounded, label: 'Analyse'),
    GlassNavDestination(icon: Icons.local_gas_station_rounded, label: 'Einträge'),
    GlassNavDestination(icon: Icons.directions_car_rounded, label: 'Fahrzeuge'),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: GlassBottomNav(
          currentIndex: navigationShell.currentIndex,
          destinations: _destinations,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
