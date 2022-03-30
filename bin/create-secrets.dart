import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> args) async {
  List<String> val;
  List<Map> val2;

  final cwd = Directory.current.path;
  final binSafe = cwd.endsWith("/bin") ? ".." : "";
  if (args.isEmpty) {
    throw ArgumentError("Expected 1-2 arguments but passed none");
  }
  if (args.contains("--local")) {
    final secretFilePath = path.join(cwd, binSafe, "secrets.json");
    final file = File(secretFilePath);
    if (!file.existsSync()) throw Exception("secrets.json file not found");
    final data = jsonDecode(await file.readAsString());
    val = List.castFrom<dynamic, String>(data["LYRICS_SECRET"]);
    val2 = List.castFrom<dynamic, Map>(data["SPOTIFY_SECRET"]);
  } else {
    final decodedLyricSecret = utf8.decode(base64Decode(args.first));
    final decodedSpotifySecrete = utf8.decode(base64Decode(args.last));
    val = List.castFrom<dynamic, String>(jsonDecode(decodedLyricSecret));
    val2 = List.castFrom<dynamic, Map>(jsonDecode(decodedSpotifySecrete));
  }

  await File(path.join(cwd, binSafe, "lib/models/generated_secrets.dart"))
      .writeAsString(
    "final List<String> lyricsSecrets = ${jsonEncode(val)};\nfinal List<Map<String, dynamic>> spotifySecrets = ${jsonEncode(val2)};",
  );
}
