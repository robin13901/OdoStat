import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/routing/app_router.dart';
import 'package:odostat/core/theme/app_theme.dart';
import 'package:odostat/core/theme/theme_mode_controller.dart';

class OdoStatApp extends ConsumerWidget {
  const OdoStatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'OdoStat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
