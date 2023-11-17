import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';

extension FetchAllTracks on InfiniteQuery<List<Track>, dynamic, int> {
  Future<List<Track>> fetchAllTracks({
    required Future<List<Track>> Function() getAllTracks,
  }) async {
    if (!hasNextPage) {
      return pages.expand((page) => page).toList();
    }
    final tracks = await getAllTracks();
    final pagedTracks = tracks.fold(
      <int, List<Track>>{},
      (acc, element) {
        final index = acc.length;
        final groupIndex = index ~/ 20;
        final group = acc[groupIndex] ?? [];
        group.add(element);
        acc[groupIndex] = group;
        return acc;
      },
    );

    for (final group in pagedTracks.entries) {
      setPageData(group.key, group.value);
    }

    return tracks.toList();
  }
}
