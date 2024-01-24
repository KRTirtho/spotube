import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

extension FetchAllTracks on InfiniteQuery<List<Track>, dynamic, int> {
  Future<List<Track>> fetchAllTracks({
    required Future<List<Track>> Function() getAllTracks,
  }) async {
    if (pages.isNotEmpty && !hasNextPage) {
      return pages.expand((page) => page).toList();
    }
    final tracks = await getAllTracks();

    final numOfPages = (tracks.length / 20).round();

    final Map<int, List<Track>> pagedTracks = {};

    for (var i = 0; i < numOfPages; i++) {
      if (i == numOfPages - 1) {
        final pageTracks = tracks.sublist(i * 20);
        pagedTracks[i] = pageTracks;
        break;
      }

      final pageTracks = tracks.sublist(i * 20, (i + 1) * 20);
      pagedTracks[i] = pageTracks;
    }

    for (final group in pagedTracks.entries) {
      setPageData(group.key, group.value);
    }

    return tracks.toList();
  }
}
