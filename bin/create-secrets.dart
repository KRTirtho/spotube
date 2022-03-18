import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> args) async {
  if (args.isEmpty) {
    throw ArgumentError("Expected an argument but none was passed");
  }

  final val = jsonDecode(args.first);
  if (val is! List) {
    throw Exception(
        "'SECRET' Environmental Variable isn't configured properly");
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString("final List<String> secrets = ${args.first};");
}
