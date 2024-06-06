import 'package:args/command_runner.dart';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';

class UntranslatedCommand extends Command {
  @override
  get name => "untranslated";
  @override
  get description =>
      "Generate Untranslated Messages for ChatGPT based Translation";

  @override
  run() async {
    final cwd = Directory.current;
    final file = jsonDecode(
      File(join(cwd.path, 'untranslated_messages.json')).readAsStringSync(),
    ) as Map<String, dynamic>;

    final englishMessages = jsonDecode(
      File(join(cwd.path, 'lib', 'l10n', 'app_en.arb')).readAsStringSync(),
    ) as Map<String, dynamic>;

    final messagesWithValues = <String, dynamic>{};

    for (final MapEntry(key: locale, value: messages) in file.entries) {
      messagesWithValues[locale] = Map.fromEntries(
        messages
            .map(
              (message) =>
                  MapEntry<String, dynamic>(message, englishMessages[message]),
            )
            .toList()
            .cast<MapEntry<String, dynamic>>(),
      );
    }

    stdout.writeln(
      "Prompt:\n"
      "Translate following to their appropriate locale for flutter arb translations files."
      " Put the respective new translations in a map of their corresponding locale.",
    );
    stdout.writeln(
      const JsonEncoder.withIndent('  ').convert(messagesWithValues),
    );
  }
}
