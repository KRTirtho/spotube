import 'dart:async';

import 'dart:convert';
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart';

class TranslatedCommand extends Command {
  @override
  String get description =>
      "Update translation based on generated translated messages";

  @override
  String get name => "translated";

  @override
  FutureOr? run() async {
    final cwd = Directory.current;
    final translatedFile = jsonDecode(
      await File(join(cwd.path, 'tm.json')).readAsString(),
    ) as Map<String, dynamic>;

    for (final MapEntry(:key, :value) in translatedFile.entries) {
      stdout.writeln('Updating locale: $key');
      final file = File(join(cwd.path, 'lib', 'l10n', 'app_$key.arb'));

      final fileContent =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;

      final newContent = {...fileContent, ...value};

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(newContent),
      );

      stdout.writeln('✅ Updated locale: $key');
    }
  }
}
