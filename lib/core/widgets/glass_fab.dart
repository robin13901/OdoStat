import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/glass_circle.dart';

/// A round, frosted-glass floating action button (Trailblazer-style).
///
/// Sits next to the bottom nav; the accent-tinted icon signals the primary
/// "add" action of the current tab.
class GlassFab extends StatelessWidget {
  const GlassFab({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 60,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onPressed,
      child: GlassCircle(
        size: size,
        child: Icon(icon, color: AppColors.accent, size: 26),
      ),
    );
    return tooltip == null
        ? button
        : Tooltip(message: tooltip, child: button);
  }
}
