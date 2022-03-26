import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:dotenv/dotenv.dart';

void main(List<String> args) async {
  String lyricSecret;
  String spotifySecret;

  if (args.isEmpty) {
    throw ArgumentError("Expected 2 arguments but passed none");
  }
  if (args.contains("--loadEnv")) {
    load();
    if (env["SPOTIFY_SECRET"] == null || env["LYRICS_SECRET"] == null) {
      throw Exception(
          "'LYRICS_SECRET' or 'SPOTIFY_SECRET' environmental variable aren't set correctly ");
    }
    lyricSecret = env["LYRICS_SECRET"]!;
    spotifySecret = env["SPOTIFY_SECRET"]!;
  } else {
    lyricSecret = args.first;
    spotifySecret = args.last;
  }

  final decodedLyricSecret = utf8.decode(base64Decode(lyricSecret));
  final decodedSpotifySecrete = utf8.decode(base64Decode(spotifySecret));
  final val = jsonDecode(decodedLyricSecret);
  final val2 = jsonDecode(decodedSpotifySecrete);
  if (val is! List || (val2 is! List && (val2 as List).first is! Map)) {
    throw Exception(
        "'LYRICS_SECRET' and 'SPOTIFY_SECRET' Environmental Variable isn't configured properly");
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString(
    "final List<String> lyricsSecrets = $decodedLyricSecret;\nfinal List<Map<String, dynamic>> spotifySecrets = $decodedSpotifySecrete;",
  );
}
