import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart' as lg;
import 'package:odostat/core/theme/liquid_glass_settings.dart';

/// Rounded "pill" of frosted glass.
///
/// When `LiquidGlassSettings.useRealGlass` is true this renders a real
/// `LiquidGlass` (Impeller shader); otherwise it falls back to a tinted,
/// hairline-bordered container that still reads as glass. OdoStat never layers
/// glass over a PlatformView, so no `overMap` guard is needed.
///
/// Shared primitive behind `GlassBottomNav` and other pill-shaped chrome.
class GlassPill extends StatelessWidget {
  const GlassPill({
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    this.borderRadius,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    const settings = LiquidGlassSettings.instance;
    final radius = borderRadius ?? settings.pillBorderRadius;
    final brightness = Theme.of(context).brightness;

    if (settings.useRealGlass) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // liquid_glass_renderer calls Picture.toImageSync during paint; a
          // 0-dim constraint throws "Invalid image dimensions". Guard against
          // transient 0-dim layout (e.g. animating chrome).
          if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
            return const SizedBox.shrink();
          }
          return lg.LiquidGlassLayer(
            settings: lg.LiquidGlassSettings(
              thickness: settings.glassThickness,
              blur: settings.glassBlurSigma,
              saturation: settings.glassSaturation,
            ),
            child: lg.LiquidGlass(
              shape: lg.LiquidRoundedSuperellipse(borderRadius: radius),
              child: Padding(padding: padding, child: child),
            ),
          );
        },
      );
    }

    return GlassFallback(
      borderRadius: radius,
      tint: settings.tintFor(brightness),
      borderColor: settings.borderFor(brightness),
      padding: padding,
      child: child,
    );
  }
}

/// Tinted fallback used when the real glass renderer is unavailable.
///
/// Public so widget tests can find it in the tree.
class GlassFallback extends StatelessWidget {
  const GlassFallback({
    required this.child,
    required this.borderRadius,
    required this.tint,
    required this.borderColor,
    this.padding = EdgeInsets.zero,
    this.shape = BoxShape.rectangle,
    super.key,
  });

  final Widget child;
  final double borderRadius;
  final Color tint;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: tint,
        border: Border.all(color: borderColor, width: 0.5),
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
        shape: shape,
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}
