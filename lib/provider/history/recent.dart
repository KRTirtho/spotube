import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/history/state.dart';

final recentlyPlayedItems = Provider((ref) {
  return ref.watch(
    playbackHistoryProvider.select(
      (s) => s.items
          .toSet()
          // unique items
          .whereIndexed(
            (index, item) =>
                index ==
                s.items.lastIndexWhere(
                  (e) => switch ((e, item)) {
                    (
                      PlaybackHistoryPlaylist(:final playlist),
                      PlaybackHistoryPlaylist(playlist: final playlist2)
                    ) =>
                      playlist.id == playlist2.id,
                    (
                      PlaybackHistoryAlbum(:final album),
                      PlaybackHistoryAlbum(album: final album2)
                    ) =>
                      album.id == album2.id,
                    _ => false,
                  },
                ),
          )
          .where(
            (s) => s is PlaybackHistoryPlaylist || s is PlaybackHistoryAlbum,
          )
          .take(10)
          .sortedBy((s) => s.date)
          .reversed
          .toList(),
    ),
  );
});
