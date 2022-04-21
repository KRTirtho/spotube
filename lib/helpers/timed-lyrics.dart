import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:collection/collection.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/models/SpotubeTrack.dart';

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

Future<SubtitleSimple?> getTimedLyrics(SpotubeTrack track) async {
  final artistNames =
      track.artists?.map((artist) => artist.name!).toList() ?? [];
  final query = getTitle(
    track.name!,
    artists: artistNames,
  );
  final searchUri = Uri.parse("$baseUri/subtitles4songs.aspx").replace(
    queryParameters: {"q": query},
  );

  final res = await http.get(searchUri);
  final document = parse(res.body);
  final results =
      document.querySelectorAll("#tablecontainer table tbody tr td a");

  final topResult = results
      .map((result) {
        final title = result.text.trim().toLowerCase();
        int points = 0;
        final hasAllArtists = track.artists
                ?.map((artist) => artist.name!)
                .every((artist) => title.contains(artist.toLowerCase())) ??
            false;
        final hasTrackName = title.contains(track.name!.toLowerCase());
        final exactYtMatch = title == track.ytTrack.title.toLowerCase();
        if (exactYtMatch) points = 8;
        for (final criteria in [hasTrackName, hasAllArtists]) {
          if (criteria) points++;
        }
        return {"result": result, "points": points};
      })
      .sorted((a, b) => (b["points"] as int).compareTo(a["points"] as int))
      .first["result"] as Element;

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
