import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dotenv/dotenv.dart';

void main() async {
  load();
  final bool hasKey = env.containsKey("SECRET");
  final val = hasKey ? jsonDecode(env["SECRET"]!) : null;
  if (!hasKey || (hasKey && val is! Map && val is! List)) {
    return;
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString(
          "final List<Map<String, dynamic>> secrets = ${env["SECRET"]};");
}
