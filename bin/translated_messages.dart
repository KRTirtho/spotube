import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  final translatedFile =
      jsonDecode(await File('tm.json').readAsString()) as Map<String, dynamic>;

  for (final MapEntry(:key, :value) in translatedFile.entries) {
    print('Updating locale: $key');
    final file = File('lib/l10n/app_$key.arb');

    final fileContent =
        jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    final newContent = {
      ...fileContent,
      ...value,
    };

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(newContent),
    );

    print('✅ Updated locale: $key');
  }
}
