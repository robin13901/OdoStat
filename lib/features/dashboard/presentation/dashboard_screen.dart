import 'package:flutter/material.dart';
import 'package:odostat/core/widgets/glass_card.dart';

/// Placeholder — replaced in the dashboard feature task.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Placeholder(title: 'Analyse', icon: Icons.insights_rounded);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: GlassCard(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48),
              const SizedBox(height: 12),
              Text('$title – in Arbeit'),
            ],
          ),
        ),
      ),
    );
  }
}
