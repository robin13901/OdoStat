import 'package:flutter/material.dart';
import 'package:odostat/core/theme/app_gradients.dart';

/// Paints the app's ember gradient backdrop behind its [child].
///
/// The theme's scaffold background is transparent, so this is what actually
/// fills the screen behind the glass chrome. Wrap the body of each screen (or
/// the shell) in this.
class GradientBackground extends StatelessWidget {
  const GradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.forBrightness(brightness),
      ),
      child: child,
    );
  }
}
