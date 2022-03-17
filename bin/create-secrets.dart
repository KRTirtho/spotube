import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dotenv/dotenv.dart';

void main() async {
  load();
  final bool hasKey = env.containsKey("SECRET");
  final val = hasKey ? jsonDecode(env["SECRET"]!) : null;
  if (!hasKey || (hasKey && val is! List)) {
    throw Exception(
        "'SECRET' Environmental Variable isn't configured properly");
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString("final List<String> secrets = ${env["SECRET"]};");
}
