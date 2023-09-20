import 'dart:convert';
import 'dart:io';
import 'package:spotube/models/logger.dart';

/// Generate JSON output for untranslated messages with English values
/// for quick translation in ChatGPT
///
/// Usage: dart bin/untranslated_messages.dart [locale?]
///
/// Example: dart bin/untranslated_messages.dart
///
/// or with specific locale (e.g. bn (Bengali))
///
/// Example: dart bin/untranslated_messages.dart bn

void main(List<String> args) {
  final logger = getLogger("");

  final file = jsonDecode(
    File('untranslated_messages.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  final englishMessages =
      jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;

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

  logger.d(
    const JsonEncoder.withIndent('  ').convert(
      args.isNotEmpty ? messagesWithValues[args.first] : messagesWithValues,
    ),
  );
}
