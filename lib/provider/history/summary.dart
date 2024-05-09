import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

final playbackHistorySummaryProvider = Provider((ref) {
  final (:tracks, :albums, :playlists) =
      ref.watch(playbackHistoryGroupedProvider);

  final totalDurationListened = tracks.fold(
    Duration.zero,
    (previousValue, element) => previousValue + element.track.duration!,
  );

  final totalTracksListened = tracks
      .whereIndexed(
        (i, track) =>
            i == tracks.lastIndexWhere((e) => e.track.id == track.track.id),
      )
      .length;

  final artists =
      tracks.map((e) => e.track.artists).expand((e) => e ?? []).toList();

  final totalArtistsListened = artists
      .whereIndexed(
        (i, artist) => i == artists.lastIndexWhere((e) => e.id == artist.id),
      )
      .length;

  final totalAlbumsListened = albums
      .whereIndexed(
        (i, album) =>
            i == albums.lastIndexWhere((e) => e.album.id == album.album.id),
      )
      .length;

  final totalPlaylistsListened = playlists
      .whereIndexed(
        (i, playlist) =>
            i ==
            playlists
                .lastIndexWhere((e) => e.playlist.id == playlist.playlist.id),
      )
      .length;

  final tracksThisMonth = ref.watch(
    playbackHistoryTopProvider(HistoryDuration.days30).select((s) => s.tracks),
  );

  final streams = tracksThisMonth.fold(0, (acc, el) => acc + el.count);

  return (
    duration: totalDurationListened,
    tracks: totalTracksListened,
    artists: totalArtistsListened,
    fees: streams * 0.005, // Spotify pays $0.003 to $0.005
    albums: totalAlbumsListened,
    playlists: totalPlaylistsListened,
  );
});
