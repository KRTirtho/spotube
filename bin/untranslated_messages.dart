import 'dart:convert';
import 'dart:io';

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

  print(
    "Prompt:\n"
    "Translate following to their appropriate locale for flutter arb translations files."
    " Put the respective new translations in a map of their corresponding locale.",
  );
  // ignore: avoid_print
  print(
    const JsonEncoder.withIndent('  ').convert(
      args.isNotEmpty ? messagesWithValues[args.first] : messagesWithValues,
    ),
  );
}
