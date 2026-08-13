import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odostat/core/db/app_database.dart';
import 'package:odostat/core/db/app_database_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

/// Result of a backup/restore operation.
sealed class BackupResult {
  const BackupResult();
}

class BackupOk extends BackupResult {
  const BackupOk(this.path);
  final String path;
}

class BackupError extends BackupResult {
  const BackupError(this.message);
  final String message;
}

/// Tables a valid OdoStat backup must contain.
const Set<String> _requiredTables = {
  'vehicles',
  'refuels',
  'odometer_readings',
};

/// Creates and restores single-file SQLite backups of the OdoStat database.
///
/// Export uses `VACUUM INTO` to produce a clean, WAL-free copy (pattern from
/// the Trailblazer reference app). Restore validates the picked file with a
/// read-only `package:sqlite3` handle before replacing the live database, then
/// invalidates [appDatabaseProvider] so the app reopens the restored file.
class BackupService {
  const BackupService(this._ref);

  final Ref _ref;

  /// Writes a backup to a temp file and returns its path.
  Future<BackupResult> createBackup() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final stamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final dest = p.join(tempDir.path, 'odostat-backup-$stamp.odostat');

      final db = _ref.read(appDatabaseProvider);
      await db.customStatement('VACUUM INTO ?', [dest]);
      return BackupOk(dest);
    } on Object catch (e) {
      return BackupError('Backup fehlgeschlagen: $e');
    }
  }

  /// Validates [path] as an OdoStat/SQLite backup.
  ///
  /// Returns null on success, or an error message.
  String? validate(String path) {
    Database? db;
    try {
      db = sqlite3.open(path, mode: OpenMode.readOnly);
      final integrity = db.select('PRAGMA integrity_check');
      final ok = integrity.isNotEmpty &&
          integrity.first.values.first == 'ok';
      if (!ok) return 'Datei ist beschädigt (integrity_check).';

      final tableRows =
          db.select("SELECT name FROM sqlite_master WHERE type='table'");
      final tables = tableRows.map((r) => r['name'] as String).toSet();
      final missing = _requiredTables.difference(tables);
      if (missing.isNotEmpty) {
        return 'Keine OdoStat-Sicherung (fehlende Tabellen: '
            '${missing.join(', ')}).';
      }
      return null;
    } on SqliteException catch (e) {
      return 'Keine gültige SQLite-Datei: $e';
    } finally {
      db?.close();
    }
  }

  /// Restores [sourcePath] over the live database.
  ///
  /// Validates first; on success closes the current DB, overwrites the file,
  /// and invalidates the provider so a fresh [AppDatabase] opens the restored
  /// data.
  Future<BackupResult> restore(String sourcePath) async {
    final error = validate(sourcePath);
    if (error != null) return BackupError(error);

    try {
      final target = await AppDatabase.databaseFile();

      // Close the live database so the file handle is released.
      await _ref.read(appDatabaseProvider).close();

      // Remove WAL/SHM sidecar files to avoid a stale journal masking the
      // freshly copied main file.
      for (final suffix in ['-wal', '-shm']) {
        final side = File('${target.path}$suffix');
        if (side.existsSync()) await side.delete();
      }

      await File(sourcePath).copy(target.path);

      // Force a rebuild of the database provider (and its dependents).
      _ref.invalidate(appDatabaseProvider);
      return BackupOk(target.path);
    } on Object catch (e) {
      return BackupError('Wiederherstellung fehlgeschlagen: $e');
    }
  }
}

final backupServiceProvider = Provider<BackupService>(BackupService.new);
