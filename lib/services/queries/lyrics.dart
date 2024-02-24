import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/map.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:http/http.dart' as http;

class LyricsQueries {
  const LyricsQueries();

  Query<String, dynamic> azLyrics(Track? track) {
    return useQuery<String, dynamic>("azlyrics-query/${track?.id}", () async {
      if (track == null) {
        throw "No Track Currently";
      }
      final lyrics = await ServiceUtils.getAZLyrics(
          title: track.name!,
          artists:
              track.artists?.map((s) => s.name).whereNotNull().toList() ?? []);
      return lyrics;
    });
  }

  Query<String, dynamic> geniusLyrics(Track? track) {
    return useQuery<String, dynamic>("geniusLyrics-query/${track?.id}",
        () async {
      if (track == null) {
        throw "No Track Currently";
      }
      final lyrics = await ServiceUtils.getGeniusLyrics(
          title: track.name!,
          artists:
              track.artists?.map((s) => s.name).whereNotNull().toList() ?? []);
      return lyrics;
    });
  }


  Query<String, dynamic> static(
    Track? track,
    String geniusAccessToken,
  ) {
    return useQuery<String, dynamic>(
      "genius-lyrics-query/${track?.id}",
      () async {
        if (track == null) {
          return "“Give this player a track to play”\n- S'Challa";
        }
        final lyrics = await ServiceUtils.getLyrics(
          track.name!,
          track.artists?.map((s) => s.name).whereNotNull().toList() ?? [],
          apiKey: geniusAccessToken,
          optimizeQuery: true,
        );

        if (lyrics == null) throw Exception("Unable find lyrics");
        return lyrics;
      },
    );
  }

  Query<SubtitleSimple, dynamic> synced(
    Track? track,
  ) {
    return useQuery<SubtitleSimple, dynamic>(
      "synced-lyrics/${track?.id}}",
      () async {
        if (track == null || track is! SourcedTrack) {
          throw "No track currently";
        }
        final timedLyrics = await ServiceUtils.getTimedLyrics(track);
        if (timedLyrics == null) throw Exception("Unable to find lyrics");

        return timedLyrics;
      },
    );
  }

  /// The Concept behind this method was shamelessly stolen from
  /// https://github.com/akashrchandran/spotify-lyrics-api
  ///
  /// Thanks to [akashrchandran](https://github.com/akashrchandran) for the idea
  ///
  /// Special thanks to [raptag](https://github.com/raptag) for discovering this
  /// jem

  Query<SubtitleSimple, Exception> spotifySynced(WidgetRef ref, Track? track) {
    return useSpotifyQuery<SubtitleSimple, Exception>(
      "spotify-synced-lyrics/${track?.id}}",
      (spotify) async {
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
      },
      jsonConfig: JsonConfig(
        fromJson: (json) => SubtitleSimple.fromJson(json.castKeyDeep<String>()),
        toJson: (data) => data.toJson(),
      ),
      ref: ref,
    );
  }
}
