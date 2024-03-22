import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';

class TracksQueries {
  const TracksQueries();

  Query<Track, dynamic> track(WidgetRef ref, String id) {
    return useSpotifyQuery(
      "track/$id",
      (spotify) => spotify.tracks.get(id),
      ref: ref,
    );
  }
}
