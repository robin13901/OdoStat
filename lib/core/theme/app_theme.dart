import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_colors.dart';

/// App-wide [ThemeData] for OdoStat.
///
/// Built from a warm-orange seed (`#FF6B35`). The scaffold is transparent so
/// the ember `AppGradients` backdrop shows through behind glass chrome; the
/// real background colour lives on a `DecoratedBox` in `GradientBackground`.
///
/// The app ships dark-first (the user runs their phone in dark mode), but a
/// coherent light theme is provided for `ThemeMode.system` / manual switching.
class AppTheme {
  const AppTheme._();

  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.accent,
          onPrimary: AppColors.onAccent,
          secondary: AppColors.accentContrast,
          error: AppColors.error,
          surface: isDark ? AppColors.surface : const Color(0xFFFBF7F4),
          onSurface: isDark ? AppColors.onSurface : const Color(0xFF1A0E08),
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      // Transparent so the gradient backdrop is visible behind everything.
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: Colors.transparent,
    );

    final onSurface = scheme.onSurface;
    final muted = isDark
        ? AppColors.onSurfaceMuted
        : const Color(0xFF6B5B50);

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, onSurface, muted),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: onSurface,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerColor: AppColors.hairline,
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: TextStyle(color: AppColors.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0x14FFFFFF) : const Color(0x0D000000),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        labelStyle: TextStyle(color: muted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, Color onSurface, Color muted) {
    return base
        .apply(bodyColor: onSurface, displayColor: onSurface)
        .copyWith(
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          bodySmall: base.bodySmall?.copyWith(color: muted),
          labelSmall: base.labelSmall?.copyWith(color: muted),
        );
  }
}
