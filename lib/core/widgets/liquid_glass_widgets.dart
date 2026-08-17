import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

LiquidGlassSettings getLiquidGlassSettings(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return LiquidGlassSettings(
    thickness: 30,
    blur: 1.4,
    glassColor: brightness == Brightness.dark
        ? const Color(0x33000000)
        : const Color(0x55000000),
  );
}

Widget buildLiquidGlassAppBar(BuildContext context,
    {required Widget title, bool showBackButton = true, List<Widget>? actions}) {
  final statusBar = MediaQuery.of(context).padding.top;
  final height = statusBar + kToolbarHeight;
  final settings = getLiquidGlassSettings(context);

  const overscan = 40.0;

  return Positioned(
    top: -overscan,
    left: -overscan,
    right: -overscan,
    height: height + overscan,
    child: LiquidGlassLayer(
      settings: settings,
      child: LiquidGlass.grouped(
        shape: const LiquidRoundedSuperellipse(borderRadius: 0),
        child: Stack(
          children: [
            Positioned(
              top: -overscan,
              left: 0,
              right: 0,
              height: height + overscan * 2,
              child: Container(),
            ),
            Positioned(
              left: overscan,
              right: overscan,
              top: statusBar + overscan,
              height: kToolbarHeight,
              child: Row(
                children: [
                  if (showBackButton)
                    const BackButton()
                  else
                    const SizedBox(width: 8),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DefaultTextStyle(
                      style: Theme.of(context).appBarTheme.titleTextStyle ??
                          Theme.of(context).textTheme.titleLarge!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title,
                    ),
                  ),
                  ...?actions,
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
