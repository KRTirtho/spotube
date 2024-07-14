import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';

/// Migrates sandbox files on macOS to non-sandbox directories
Future<void> migrateMacOsFromSandboxToNoSandbox() async {
  if (!kIsMacOS) return;

  try {
    final sandboxApplicationSupportDir = Directory(
      "/Users/${Platform.environment["USER"]}/Library/Containers/oss.krtirtho.spotube/Data/Library/Application Support/oss.krtirtho.spotube",
    );

    if (!await sandboxApplicationSupportDir.exists()) {
      stdout.writeln("🔵 Sandbox directory not found, skipping migration");
      return;
    }

    const fileExts = [".db", ".lock", ".hive"];

    final supportDir = await getApplicationSupportDirectory()
      ..create(recursive: true);

    final supportFiles = await supportDir.list().toList();
    final oldSupportFiles = await sandboxApplicationSupportDir.list().toList();

    if (oldSupportFiles.isEmpty) {
      stdout.writeln(
        "🔵 No files found in sandboxed directory, skipping migration",
      );
      return;
    } else if (supportFiles.any(
        (file) => file is File && fileExts.contains(extension(file.path)))) {
      stdout.writeln(
        "🔵 Non-sandbox directory is not empty, skipping migration",
      );
      return;
    }

    for (final oldSupportFile in oldSupportFiles) {
      if (oldSupportFile is File &&
          fileExts.contains(extension(oldSupportFile.path))) {
        final newPath = join(supportDir.path, basename(oldSupportFile.path));
        await oldSupportFile.copy(newPath);
      }
    }

    stdout.writeln("✅ Migrated sandboxed files to non-sandboxed directory");
  } catch (e, stack) {
    stdout.writeln(
      "❌ Error migrating sandboxed files to non-sandboxed directory",
    );
    AppLogger.reportError(e, stack);
  }
}
