import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/history/history.dart';

final playbackHistoryTopProvider = Provider((ref) {
  final (:tracks, :albums, playlists: _) =
      ref.watch(playbackHistoryGroupedProvider);

  final tracksWithCount = groupBy(tracks, (track) => track.track.id!)
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

  return (
    tracks: tracksWithCount,
    albums: albumsWithCount,
    artists: artistsWithCount
  );
});
