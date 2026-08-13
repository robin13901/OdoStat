import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/widgets/glass_pill.dart';

/// A single destination in the [GlassBottomNav].
class GlassNavDestination {
  const GlassNavDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Stadium-shaped frosted-glass bottom navigation bar.
///
/// Floats above the content (the caller positions it with padding), mirroring
/// the Trailblazer `BottomNavShell` look but adapted to OdoStat's tabs.
class GlassBottomNav extends StatelessWidget {
  const GlassBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Center(
          child: GlassPill(
            borderRadius: 999,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(destinations.length, (i) {
                final d = destinations[i];
                final selected = i == currentIndex;
                final color = selected
                    ? AppColors.accent
                    : theme.colorScheme.onSurface.withValues(alpha: 0.55);
                return _NavItem(
                  icon: d.icon,
                  label: d.label,
                  color: color,
                  selected: selected,
                  onTap: () => onTap(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
