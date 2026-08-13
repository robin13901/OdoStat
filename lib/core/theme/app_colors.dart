import 'package:flutter/material.dart';

/// Central design tokens for OdoStat.
///
/// Dark-first "liquid glass" look: a warm-orange accent (`#FF6B35`) over a
/// near-black GitHub-dark surface (`#0D1117`), with a subtle ember gradient
/// (`#1A0508` → `#FF6B35`) painted behind frosted-glass chrome.
///
/// Colours are grouped into three layers so the whole app stays consistent:
///   * [accent] family — the orange brand hue + supporting tints.
///   * surface family — the dark backdrop and its raised variants.
///   * semantic family — success / warning / error tuned to sit on dark.
class AppColors {
  const AppColors._();

  // --- Brand accent -------------------------------------------------------
  /// Primary brand accent — buttons, active states, chart line A.
  static const Color accent = Color(0xFFFF6B35);

  /// Lighter accent for hover/pressed highlights and gradients.
  static const Color accentBright = Color(0xFFFF8C5A);

  /// Deep ember used as the gradient origin behind glass.
  static const Color accentDeep = Color(0xFF1A0508);

  /// A cool cyan used as the contrasting second series in comparison charts
  /// (readable against orange without clashing).
  static const Color accentContrast = Color(0xFF35C7FF);

  // --- Dark surfaces ------------------------------------------------------
  /// App scaffold background (GitHub dark).
  static const Color surface = Color(0xFF0D1117);

  /// Slightly raised surface (behind cards / sheets).
  static const Color surfaceRaised = Color(0xFF161B22);

  /// Highest raised surface (dialogs, menus).
  static const Color surfaceHigh = Color(0xFF1C2230);

  // --- On-colours ---------------------------------------------------------
  /// Primary foreground text on dark surfaces.
  static const Color onSurface = Color(0xFFF0F3F8);

  /// Muted foreground (labels, secondary text, inactive icons).
  static const Color onSurfaceMuted = Color(0xFF9BA4B0);

  /// Foreground painted on top of the [accent] colour.
  static const Color onAccent = Color(0xFF1A0508);

  // --- Semantic -----------------------------------------------------------
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFACC15);
  static const Color error = Color(0xFFFF5C5C);

  // --- Hairlines ----------------------------------------------------------
  /// Subtle divider / outline on dark.
  static const Color hairline = Color(0x1FFFFFFF);
}

/// Corner radii used across the app.
class AppRadii {
  const AppRadii._();

  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;
  static const double pill = 999;
}

/// Spacing scale (4-pt based).
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}
