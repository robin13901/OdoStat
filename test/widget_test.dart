import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:odostat/app.dart';

void main() {
  testWidgets('App boots and shows the dashboard shell', (tester) async {
    await initializeDateFormatting('de_DE');
    await tester.pumpWidget(const ProviderScope(child: OdoStatApp()));
    await tester.pumpAndSettle();

    // Bottom-nav labels + app bar title are present.
    expect(find.text('Analyse'), findsWidgets);
    expect(find.byIcon(Icons.local_gas_station_rounded), findsOneWidget);
  });
}
