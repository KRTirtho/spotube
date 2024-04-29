import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/history/history.dart';

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

  return (
    duration: totalDurationListened,
    tracks: totalTracksListened,
    artists: totalArtistsListened,
    albums: totalAlbumsListened,
    playlists: totalPlaylistsListened,
  );
});
