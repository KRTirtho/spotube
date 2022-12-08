class SubtitleSimple {
  Uri uri;
  String name;
  List<LyricSlice> lyrics;
  int rating;
  SubtitleSimple({
    required this.uri,
    required this.name,
    required this.lyrics,
    required this.rating,
  });
}

class LyricSlice {
  Duration time;
  String text;

  LyricSlice({required this.time, required this.text});

  @override
  String toString() {
    return "LyricsSlice({time: $time, text: $text})";
  }
}
