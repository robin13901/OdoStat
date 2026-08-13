import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:odostat/app.dart';
import 'package:odostat/core/theme/liquid_glass_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Locale data for de_DE date formatting (DateFormat with an explicit locale).
  await initializeDateFormatting('de_DE');

  // Enable the real liquid-glass shader. OdoStat never layers glass over a
  // PlatformView, so the renderer is safe wherever Impeller is available;
  // GlassPill/GlassCircle fall back to a tinted look otherwise.
  LiquidGlassSettings.platformBlurEnabled = true;

  runApp(const ProviderScope(child: OdoStatApp()));
}
