import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as lg;
import 'package:odostat/core/theme/liquid_glass_settings.dart';
import 'package:odostat/core/widgets/glass_pill.dart';

/// Circular glass button surface (e.g. a floating action / icon button).
class GlassCircle extends StatelessWidget {
  const GlassCircle({
    required this.size,
    required this.child,
    super.key,
  });

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const settings = LiquidGlassSettings.instance;
    final brightness = Theme.of(context).brightness;

    if (settings.useRealGlass) {
      if (size <= 0) return const SizedBox.shrink();
      return SizedBox(
        width: size,
        height: size,
        child: lg.LiquidGlassLayer(
          settings: lg.LiquidGlassSettings(
            thickness: settings.glassThickness,
            blur: settings.glassBlurSigma,
            saturation: settings.glassSaturation,
          ),
          child: lg.LiquidGlass(
            shape: lg.LiquidRoundedSuperellipse(borderRadius: size / 2),
            child: Center(child: child),
          ),
        ),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: GlassFallback(
        borderRadius: size / 2,
        shape: BoxShape.circle,
        tint: settings.tintFor(brightness),
        borderColor: settings.borderFor(brightness),
        child: Center(child: child),
      ),
    );
  }
}
