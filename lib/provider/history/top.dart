import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/history/state.dart';

final playbackHistoryTopDurationProvider =
    StateProvider((ref) => HistoryDuration.days30);

final playbackHistoryTopProvider =
    Provider.family((ref, HistoryDuration durationState) {
  final grouped = ref.watch(playbackHistoryGroupedProvider);

  final duration = switch (durationState) {
    HistoryDuration.allTime => const Duration(days: 365 * 2003),
    HistoryDuration.days7 => const Duration(days: 7),
    HistoryDuration.days30 => const Duration(days: 30),
    HistoryDuration.months6 => const Duration(days: 30 * 6),
    HistoryDuration.year => const Duration(days: 365),
    HistoryDuration.years2 => const Duration(days: 365 * 2),
  };
  final tracks = grouped.tracks
      .where(
        (item) => item.date.isAfter(
          DateTime.now().subtract(duration),
        ),
      )
      .toList();
  final albums = grouped.albums
      .where(
        (item) => item.date.isAfter(
          DateTime.now().subtract(duration),
        ),
      )
      .toList();

  final playlists = grouped.playlists
      .where(
        (item) => item.date.isAfter(
          DateTime.now().subtract(duration),
        ),
      )
      .toList();

  final tracksWithCount = groupBy(
    tracks,
    (track) => track.track.id!,
  )
      .entries
      .map((entry) {
        return (count: entry.value.length, track: entry.value.first.track);
      })
      .sorted((a, b) => b.count.compareTo(a.count))
      .toList();

  final albumsWithTrackAlbums = [
    for (final historicAlbum in albums) historicAlbum.album,
    for (final track in tracks) track.track.album!
  ];

  final albumsWithCount = groupBy(albumsWithTrackAlbums, (album) => album.id!)
      .entries
      .map((entry) {
        return (count: entry.value.length, album: entry.value.first);
      })
      .sorted((a, b) => b.count.compareTo(a.count))
      .toList();

  final artists =
      tracks.map((track) => track.track.artists).expand((e) => e ?? <Artist>[]);

  final artistsWithCount = groupBy(artists, (artist) => artist.id!)
      .entries
      .map((entry) {
        return (count: entry.value.length, artist: entry.value.first);
      })
      .sorted((a, b) => b.count.compareTo(a.count))
      .toList();

  final playlistsWithCount =
      groupBy(playlists, (playlist) => playlist.playlist.id!)
          .entries
          .map((entry) {
            return (count: entry.value.length, playlist: entry.value.first);
          })
          .sorted((a, b) => b.count.compareTo(a.count))
          .toList();

  return (
    tracks: tracksWithCount,
    albums: albumsWithCount,
    artists: artistsWithCount,
    playlists: playlistsWithCount,
  );
});
