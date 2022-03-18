import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

void main() async {
  final env = Platform.environment;
  final bool hasKey = env.containsKey("SECRET");
  final val = hasKey ? jsonDecode(env["SECRET"]!) : null;
  print("SECRET VALUE: ${env["SECRET"]}");
  if (!hasKey || (hasKey && val is! List)) {
    throw Exception(
        "'SECRET' Environmental Variable isn't configured properly");
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString("final List<String> secrets = ${env["SECRET"]};");
}
