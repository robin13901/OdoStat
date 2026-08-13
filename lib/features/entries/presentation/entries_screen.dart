import 'package:flutter/material.dart';
import 'package:odostat/core/widgets/glass_card.dart';

/// Placeholder — replaced in the entries feature task.
class EntriesScreen extends StatelessWidget {
  const EntriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Einträge')),
      body: const Center(
        child: GlassCard(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(32),
          child: Text('Einträge – in Arbeit'),
        ),
      ),
    );
  }
}
