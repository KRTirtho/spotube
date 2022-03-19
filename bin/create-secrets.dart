import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

void main(List<String> args) async {
  if (args.isEmpty) {
    throw ArgumentError(
        "Expected 2 arguments but passed ${args.length < 2 || args.length > 2 ? args.length : "none"}");
  }

  final decodedSecret = utf8.decode(base64Decode(args.first));
  final decodedSpotifySecrete = utf8.decode(base64Decode(args.last));
  final val = jsonDecode(decodedSecret);
  final val2 = jsonDecode(decodedSpotifySecrete);
  if (val is! List || (val2 is! List && (val2 as List).first is! Map)) {
    throw Exception(
        "'LYRICS_SECRET' and 'SPOTIFY_SECRET' Environmental Variable isn't configured properly");
  }

  await File(path.join(
          Directory.current.path, "lib/models/generated_secrets.dart"))
      .writeAsString(
    "final List<String> lyricsSecrets = $decodedSecret;\nfinal List<Map<String, dynamic>> spotifySecrets = $decodedSpotifySecrete;",
  );
}
