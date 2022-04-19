import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/getLyrics.dart';

class SubtitleSimple {
  Uri uri;
  String name;
  List<LyricSlice> lyrics;
  SubtitleSimple({
    required this.uri,
    required this.name,
    required this.lyrics,
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

const baseUri = "https://www.rentanadviser.com/subtitles";

Future<SubtitleSimple?> getTimedLyrics(Track track) async {
  final artistNames =
      track.artists?.map((artist) => artist.name!).toList() ?? [];
  final query = getTitle(
    clearArtistsOfTitle(track.name!, artistNames),
    artistNames,
  );
  final searchUri = Uri.parse("$baseUri/subtitles4songs.aspx").replace(
    queryParameters: {"q": query},
  );

  final res = await http.get(searchUri);
  final document = parse(res.body);
  final topResult =
      document.querySelector("#tablecontainer table tbody tr td a");

  if (topResult == null) return null;

  final subtitleUri =
      Uri.parse("$baseUri/${topResult.attributes["href"]}&type=lrc");

  final lrcDocument = parse((await http.get(subtitleUri)).body);
  final lrcList = lrcDocument
          .querySelector("#ctl00_ContentPlaceHolder1_lbllyrics")
          ?.innerHtml
          .replaceAll(RegExp(r'<h3>.*</h3>'), "")
          .split("<br>")
          .map((e) {
        e = e.trim();
        final regexp = RegExp(r'\[.*\]');
        final timeStr = regexp
            .firstMatch(e)
            ?.group(0)
            ?.replaceAll(RegExp(r'\[|\]'), "")
            .trim()
            .split(":");
        final minuteSeconds = timeStr?.last.split(".");

        return LyricSlice(
            time: Duration(
              minutes: int.parse(timeStr?.first ?? "0"),
              seconds: int.parse(minuteSeconds?.first ?? "0"),
              milliseconds: int.parse(minuteSeconds?.last ?? "0"),
            ),
            text: e.split(regexp).last);
      }).toList() ??
      [];

  final subtitle = SubtitleSimple(
    name: topResult.text.trim(),
    uri: subtitleUri,
    lyrics: lrcList,
  );

  return subtitle;
}
