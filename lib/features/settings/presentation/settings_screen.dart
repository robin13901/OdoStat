import 'package:flutter/material.dart';
import 'package:odostat/core/widgets/glass_card.dart';

/// Placeholder — replaced in the settings feature task.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Einstellungen')),
      body: const Center(
        child: GlassCard(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(32),
          child: Text('Einstellungen – in Arbeit'),
        ),
      ),
    );
  }
}
