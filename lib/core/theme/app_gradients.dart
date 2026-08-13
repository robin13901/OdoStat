import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_colors.dart';

/// Background gradients painted behind the glass chrome.
class AppGradients {
  const AppGradients._();

  /// The signature ember backdrop: deep near-black at the top fading into a
  /// warm orange glow at the bottom. Kept subtle so glass + content stay
  /// readable; the orange is anchored low so most of the screen is dark.
  static const LinearGradient emberDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.surface, // #0D1117
      AppColors.accentDeep, // #1A0508
      Color(0xFF3D1509), // interpolated ember
      Color(0xFF7A2E12), // warm mid
    ],
    stops: [0.0, 0.45, 0.78, 1.0],
  );

  /// Light-mode backdrop (soft warm off-white → faint orange).
  static const LinearGradient emberLight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFBF7F4), Color(0xFFFDE7DC)],
    stops: [0.0, 1.0],
  );

  static LinearGradient forBrightness(Brightness b) =>
      b == Brightness.dark ? emberDark : emberLight;
}
