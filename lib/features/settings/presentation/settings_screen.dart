import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/theme/app_colors.dart';
import 'package:odostat/core/theme/theme_mode_controller.dart';
import 'package:odostat/core/widgets/glass_card.dart';
import 'package:odostat/core/widgets/gradient_background.dart';
import 'package:odostat/core/widgets/liquid_glass_widgets.dart';
import 'package:odostat/features/settings/data/backup_service.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 76, 16, 40),
              children: const [
                _BackupSection(),
                SizedBox(height: 16),
                _ThemeSection(),
                SizedBox(height: 16),
                _AboutSection(),
              ],
            ),
            buildLiquidGlassAppBar(context, title: const Text('Einstellungen')),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, this.icon);
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _BackupSection extends ConsumerWidget {
  const _BackupSection();

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await ref.read(backupServiceProvider).createBackup();
    switch (result) {
      case BackupOk(:final path):
        // share_plus 10.x: the classic Share API is current for this version.
        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [XFile(path)],
          subject: 'OdoStat Sicherung',
        );
      case BackupError(:final message):
        messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final picked = await FilePicker.pickFiles();
    final path = picked?.files.singleOrNull?.path;
    if (path == null) return;

    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sicherung importieren?'),
        content: const Text(
          'Alle aktuellen Daten in OdoStat werden durch die Sicherung '
          'ERSETZT. Erstelle vorher ggf. ein Backup.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Importieren'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final result = await ref.read(backupServiceProvider).restore(path);
    switch (result) {
      case BackupOk():
        messenger.showSnackBar(
          const SnackBar(content: Text('Sicherung wiederhergestellt.')),
        );
      case BackupError(:final message):
        messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Datensicherung', Icons.backup_rounded),
          const SizedBox(height: 8),
          Text(
            'Exportiere die gesamte Datenbank als Datei oder stelle eine '
            'frühere Sicherung wieder her.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => unawaited(_export(context, ref)),
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Exportieren'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => unawaited(_import(context, ref)),
                  icon: const Icon(Icons.file_download_rounded),
                  label: const Text('Importieren'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeSection extends ConsumerWidget {
  const _ThemeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Darstellung', Icons.palette_rounded),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dunkel'),
                icon: Icon(Icons.dark_mode_rounded),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Hell'),
                icon: Icon(Icons.light_mode_rounded),
              ),
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.settings_suggest_rounded),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                unawaited(ref.read(themeModeProvider.notifier).set(s.first)),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Über', Icons.info_outline_rounded),
          const SizedBox(height: 8),
          Text(
            'OdoStat — Tankvorgänge, Ladevorgänge und Kilometerstände für '
            'mehrere Fahrzeuge, mit Analyse-Dashboard.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
