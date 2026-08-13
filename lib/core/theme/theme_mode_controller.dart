import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and exposes the user's [ThemeMode] preference.
///
/// Defaults to [ThemeMode.dark] — the app is designed dark-first.
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.dark) {
    unawaited(_load());
  }

  static const _prefsKey = 'theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefsKey);
    state = switch (stored) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) => ThemeModeController(),
);
