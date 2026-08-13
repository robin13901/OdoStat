import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:odostat/core/widgets/app_shell.dart';
import 'package:odostat/features/dashboard/presentation/dashboard_screen.dart';
import 'package:odostat/features/entries/presentation/entries_screen.dart';
import 'package:odostat/features/settings/presentation/settings_screen.dart';
import 'package:odostat/features/vehicles/presentation/vehicles_screen.dart';

final _rootKey = GlobalKey<NavigatorState>();

/// Top-level GoRouter.
///
///   0: '/'          → DashboardScreen (analysis + charts)
///   1: '/entries'   → EntriesScreen (refuels/charges + odometer readings)
///   2: '/vehicles'  → VehiclesScreen (manage vehicles)
///
/// '/settings' is a separate top-level route reachable from the dashboard
/// app bar (kept out of the bottom-nav pill).
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/entries',
              builder: (context, state) => const EntriesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/vehicles',
              builder: (context, state) => const VehiclesScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
