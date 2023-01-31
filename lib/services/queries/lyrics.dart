import 'package:collection/collection.dart';
import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:tuple/tuple.dart';

class LyricsQueries {
  final static = QueryJob.withVariableKey<String, Tuple2<Track?, String>>(
    preQueryKey: "genius-lyrics-query",
    refetchOnExternalDataChange: true,
    task: (queryKey, externalData) async {
      final currentTrack = externalData.item1;
      final geniusAccessToken = externalData.item2;
      if (currentTrack == null || getVariable(queryKey).isEmpty) {
        return "“Give this player a track to play”\n- S'Challa";
      }
      final lyrics = await ServiceUtils.getLyrics(
        currentTrack.name!,
        currentTrack.artists?.map((s) => s.name).whereNotNull().toList() ?? [],
        apiKey: geniusAccessToken,
        optimizeQuery: true,
      );

      if (lyrics == null) throw Exception("Unable find lyrics");
      return lyrics;
    },
  );

  final synced = QueryJob.withVariableKey<SubtitleSimple, SpotubeTrack?>(
    preQueryKey: "synced-lyrics",
    task: (queryKey, currentTrack) async {
      if (currentTrack == null || getVariable(queryKey).isEmpty) {
        throw "No track currently";
      }

      final timedLyrics = await ServiceUtils.getTimedLyrics(currentTrack);
      if (timedLyrics == null) throw Exception("Unable to find lyrics");

      return timedLyrics;
    },
  );
}
