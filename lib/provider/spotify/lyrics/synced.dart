part of '../spotify.dart';

class SyncedLyricsNotifier extends FamilyAsyncNotifier<SubtitleSimple, Track?>
    with Persistence<SubtitleSimple> {
  SyncedLyricsNotifier() {
    load();
  }

  @override
  FutureOr<SubtitleSimple> build(track) async {
    final spotify = ref.watch(spotifyProvider);
    if (track == null) {
      throw "No track currently";
    }
    final token = await spotify.getCredentials();
    final res = await http.get(
        Uri.parse(
          "https://spclient.wg.spotify.com/color-lyrics/v2/track/${track.id}?format=json&market=from_token",
        ),
        headers: {
          "User-Agent":
              "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.0.0 Safari/537.36",
          "App-platform": "WebPlayer",
          "authorization": "Bearer ${token.accessToken}"
        });

    if (res.statusCode != 200) {
      throw Exception("Unable to find lyrics");
    }
    final linesRaw = Map.castFrom<dynamic, dynamic, String, dynamic>(
      jsonDecode(res.body),
    )["lyrics"]?["lines"] as List?;

    final lines = linesRaw?.map((line) {
          return LyricSlice(
            time: Duration(milliseconds: int.parse(line["startTimeMs"])),
            text: line["words"] as String,
          );
        }).toList() ??
        [];

    return SubtitleSimple(
      lyrics: lines,
      name: track.name!,
      uri: res.request!.url,
      rating: 100,
    );
  }

  @override
  FutureOr<SubtitleSimple> fromJson(Map<String, dynamic> json) =>
      SubtitleSimple.fromJson(json.castKeyDeep<String>());

  @override
  Map<String, dynamic> toJson(SubtitleSimple data) => data.toJson();
}
