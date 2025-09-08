import 'package:lrc/lrc.dart';

class SubtitleSimple {
  Uri uri;
  String name;
  List<LyricSlice> lyrics;
  int rating;
  String provider;

  SubtitleSimple({
    required this.uri,
    required this.name,
    required this.lyrics,
    required this.rating,
    required this.provider,
  });

  factory SubtitleSimple.fromJson(Map<String, dynamic> json) {
    return SubtitleSimple(
      uri: Uri.parse(json["uri"] as String),
      name: json["name"] as String,
      lyrics: (json["lyrics"] as List<dynamic>)
          .map((e) => LyricSlice.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: json["rating"] as int,
      provider: json["provider"] as String? ?? "unknown",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uri": uri.toString(),
      "name": name,
      "lyrics": lyrics.map((e) => e.toJson()).toList(),
      "rating": rating,
      "provider": provider,
    };
  }
}

class LyricSlice {
  Duration time;
  String text;

  LyricSlice({required this.time, required this.text});

  factory LyricSlice.fromLrcLine(LrcLine line) {
    return LyricSlice(
      time: line.timestamp,
      text: line.lyrics.trim(),
    );
  }

  factory LyricSlice.fromJson(Map<String, dynamic> json) {
    return LyricSlice(
      time: Duration(milliseconds: json["time"]),
      text: json["text"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "time": time.inMilliseconds,
      "text": text,
    };
  }

  @override
  String toString() {
    return "LyricsSlice({time: $time, text: $text})";
  }
}
