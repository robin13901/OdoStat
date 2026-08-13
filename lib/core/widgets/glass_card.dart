import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/theme/liquid_glass_settings.dart';

/// A frosted-glass card used for list items and dashboard metric tiles.
///
/// Unlike `GlassPill`/`GlassCircle` this deliberately does NOT use the real
/// `LiquidGlass` shader: cards are large, numerous (long lists, chart panels)
/// and often nested, where per-card shader layers are expensive and can clip
/// oddly. Instead it uses a tuned tinted surface + hairline border that reads
/// as glass over the ember backdrop and stays cheap to scroll.
class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    const settings = LiquidGlassSettings.instance;
    final brightness = Theme.of(context).brightness;
    final radius = borderRadius ?? 20;

    return Padding(
      padding: margin,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: brightness == Brightness.dark
                ? const [Color(0x1FFFFFFF), Color(0x0AFFFFFF)]
                : const [Color(0x59FFFFFF), Color(0x1FFFFFFF)],
          ),
          border: Border.all(color: settings.borderFor(brightness), width: 0.5),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              splashColor: AppColors.accent.withValues(alpha: 0.12),
              highlightColor: AppColors.accent.withValues(alpha: 0.06),
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
