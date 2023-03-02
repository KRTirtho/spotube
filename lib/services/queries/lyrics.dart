import 'package:collection/collection.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/utils/service_utils.dart';

class LyricsQueries {
  const LyricsQueries();

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
        if (track == null || track is! SpotubeTrack) {
          throw "No track currently";
        }
        final timedLyrics = await ServiceUtils.getTimedLyrics(track);
        if (timedLyrics == null) throw Exception("Unable to find lyrics");

        return timedLyrics;
      },
    );
  }
}
