import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';

/// Shared visual settings for all liquid-glass chrome in OdoStat.
///
/// Adapted from the Trailblazer reference app, but simplified: OdoStat has no
/// map / PlatformView, so glass is layered only over Flutter-rasterised
/// surfaces. That means the "black box over the map" caveat does not apply and
/// the real blur can be used on every platform where the renderer is enabled.
///
/// [platformBlurEnabled] is set once at startup (see `main.dart`). When
/// `false` (or on platforms without a working shader path), glass widgets fall
/// back to a tinted, hairline-bordered container that still reads as "glass".
class LiquidGlassSettings {
  const LiquidGlassSettings._();

  static const LiquidGlassSettings instance = LiquidGlassSettings._();

  /// Set once at app startup after deciding whether the renderer is safe on
  /// the current platform. Default `false` = safe fallback path.
  // ignore: avoid_non_final_static_fields — flag is set once at startup.
  static bool platformBlurEnabled = false;

  /// The `liquid_glass_renderer` is designed for the Impeller shader path.
  /// Enable it on mobile; fall back elsewhere (desktop/web) to the tinted look.
  bool get platformSupportsBlur =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Whether the real glass effect should be used right now.
  bool get useRealGlass => platformBlurEnabled && platformSupportsBlur;

  // --- Visual parameters --------------------------------------------------
  double get glassThickness => 18;
  double get glassBlurSigma => 14;
  double get glassSaturation => 1.15;
  double get pillBorderRadius => 28;

  // --- Tints & borders (dark-first; the app runs primarily in dark) -------
  /// Tint fill for glass over the dark ember backdrop.
  Color get darkGlassTint => const Color(0x24FFFFFF);

  /// Hairline border for glass on dark.
  Color get darkGlassBorder => const Color(0x33FFFFFF);

  /// Light-mode tint (app ships dark-first, but light is supported).
  Color get lightGlassTint => const Color(0x40FFFFFF);
  Color get lightGlassBorder => const Color(0x59FFFFFF);

  Color tintFor(Brightness b) =>
      b == Brightness.dark ? darkGlassTint : lightGlassTint;

  Color borderFor(Brightness b) =>
      b == Brightness.dark ? darkGlassBorder : lightGlassBorder;
}
