import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

// blob metadata for de-stringifying
const randHash = [
  49,
  111,
  98,
  72,
  78,
  122,
  98,
  48,
  112,
  73,
  81,
  50,
  112,
  89,
  90,
  50,
  116,
  83,
  84,
  110,
  99,
  105,
  76,
  67,
  74,
  67,
  89,
  121,
  48,
  119,
  77,
  106,
  69,
  50,
  86,
  69,
  53,
  107,
  77,
  69,
  86,
  71,
  101,
  68,
  66,
  113,
  78,
  110,
  66,
  119
];
const sugarCarbonator = [
  81,
  119,
  79,
  71,
  85,
  53,
  78,
  50,
  69,
  52,
  90,
  68,
  107,
  120,
  77,
  87,
  89,
  52,
  89,
  84,
  73
];
const randomSalt = [
  70,
  117,
  67,
  75,
  117,
  116,
  72,
  101,
  105,
  102,
  65,
  110,
  68,
  87,
  72,
  97,
  84,
  85,
  82,
  100,
  79,
  73,
  110,
  103,
  83,
  117,
  75,
  115
];
const algorithmicSugar = [
  70,
  117,
  67,
  75,
  117,
  116,
  72,
  101,
  105,
  102,
  65,
  78,
  100,
  102,
  68,
  114,
  79,
  105,
  100,
  115,
  85,
  99,
  107,
  83
];

void main(List<String> args) async {
  List<String> val;
  List<Map> val2;

  final cwd = Directory.current.path;
  final binSafe = cwd.endsWith("/bin") ? ".." : "";
  if (args.isEmpty) {
    throw ArgumentError("Expected 1-3 arguments but passed none");
  }
  if (args.contains("--local")) {
    final secretFilePath = path.join(cwd, binSafe, "secrets.json");
    final file = File(secretFilePath);
    if (!file.existsSync()) throw Exception("secrets.json file not found");
    final data = jsonDecode(await file.readAsString());
    val = List.castFrom<dynamic, String>(data["LYRICS_SECRET"]);
    val2 = List.castFrom<dynamic, Map>(data["SPOTIFY_SECRET"]);
  } else if (args.contains("--fdroid")) {
    final decodedLyricSecret = utf8.decode(base64Decode(
      args[1].replaceAll(
          String.fromCharCodes(randomSalt), String.fromCharCodes(randHash)),
    ));
    final decodedSpotifySecret = utf8.decode(base64Decode(
      args.last.replaceAll(String.fromCharCodes(algorithmicSugar),
          String.fromCharCodes(sugarCarbonator)),
    ));
    val = List.castFrom<dynamic, String>(jsonDecode(decodedLyricSecret));
    val2 = List.castFrom<dynamic, Map>(jsonDecode(decodedSpotifySecret));
  } else {
    final decodedLyricSecret = utf8.decode(base64Decode(args.first));
    final decodedSpotifySecret = utf8.decode(base64Decode(args.last));
    val = List.castFrom<dynamic, String>(jsonDecode(decodedLyricSecret));
    val2 = List.castFrom<dynamic, Map>(jsonDecode(decodedSpotifySecret));
  }

  await File(path.join(cwd, binSafe, "lib/models/generated_secrets.dart"))
      .writeAsString(
    "final List<String> lyricsSecrets = ${jsonEncode(val)};\nfinal List<Map<String, dynamic>> spotifySecrets = ${jsonEncode(val2)};",
  );
}
