import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

enum HistoryDuration {
  allTime(Duration(days: 365 * 2003)),
  days7(Duration(days: 7)),
  days30(Duration(days: 30)),
  months6(Duration(days: 30 * 6)),
  year(Duration(days: 365)),
  years2(Duration(days: 365 * 2));

  final Duration duration;

  const HistoryDuration(this.duration);
}

final playbackHistoryTopDurationProvider =
    StateProvider((ref) => HistoryDuration.days30);

typedef PlaybackHistoryAlbum = ({int count, AlbumSimple album});
typedef PlaybackHistoryPlaylist = ({int count, PlaylistSimple playlist});
typedef PlaybackHistoryTrack = ({int count, Track track});
typedef PlaybackHistoryArtist = ({int count, Artist artist});

class PlaybackHistoryTopState {
  final List<PlaybackHistoryTrack> tracks;
  final List<PlaybackHistoryAlbum> albums;
  final List<PlaybackHistoryPlaylist> playlists;
  final List<PlaybackHistoryArtist> artists;

  const PlaybackHistoryTopState({
    required this.tracks,
    required this.albums,
    required this.playlists,
    required this.artists,
  });

  PlaybackHistoryTopState copyWith({
    List<PlaybackHistoryTrack>? tracks,
    List<PlaybackHistoryAlbum>? albums,
    List<PlaybackHistoryPlaylist>? playlists,
    List<PlaybackHistoryArtist>? artists,
  }) {
    return PlaybackHistoryTopState(
      tracks: tracks ?? this.tracks,
      albums: albums ?? this.albums,
      playlists: playlists ?? this.playlists,
      artists: artists ?? this.artists,
    );
  }
}

class PlaybackHistoryTopNotifier
    extends FamilyAsyncNotifier<PlaybackHistoryTopState, HistoryDuration> {
  @override
  build(arg) async {
    final database = ref.watch(databaseProvider);

    final duration = arg.duration;

    final tracksQuery = (database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(HistoryEntryType.track) &
            tbl.createdAt.isBiggerOrEqualValue(
              DateTime.now().subtract(duration),
            ),
      ));

    final albumsQuery = database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(HistoryEntryType.album) &
            tbl.createdAt.isBiggerOrEqualValue(
              DateTime.now().subtract(duration),
            ),
      );

    final playlistsQuery = database.select(database.historyTable)
      ..where(
        (tbl) =>
            tbl.type.equalsValue(HistoryEntryType.playlist) &
            tbl.createdAt.isBiggerOrEqualValue(
              DateTime.now().subtract(duration),
            ),
      );

    final subscriptions = <StreamSubscription>[
      tracksQuery.watch().listen((event) {
        if (state.asData == null) return;
        final artists = event
            .map((track) => track.track!.artists)
            .expand((e) => e ?? <Artist>[]);
        state = AsyncData(state.asData!.value.copyWith(
          tracks: getTracksWithCount(event),
          artists: getArtistsWithCount(artists),
        ));
      }),
      albumsQuery.watch().listen((event) async {
        if (state.asData == null) return;
        final tracks = await tracksQuery.get();

        final albumsWithTrackAlbums = [
          for (final historicAlbum in event) historicAlbum.album!,
          for (final track in tracks) track.track!.album!
        ];

        state = AsyncData(state.asData!.value.copyWith(
          albums: getAlbumsWithCount(albumsWithTrackAlbums),
        ));
      }),
      playlistsQuery.watch().listen((event) {
        if (state.asData == null) return;
        state = AsyncData(state.asData!.value.copyWith(
          playlists: getPlaylistsWithCount(event),
        ));
      }),
    ];

    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });

    return database.transaction(() async {
      final tracks = await tracksQuery.get();
      final albums = await albumsQuery.get();
      final playlists = await playlistsQuery.get();

      final tracksWithCount = getTracksWithCount(tracks);

      final albumsWithTrackAlbums = [
        for (final historicAlbum in albums) historicAlbum.album!,
        for (final track in tracks) track.track!.album!
      ];

      final albumsWithCount = getAlbumsWithCount(albumsWithTrackAlbums);

      final artists = tracks
          .map((track) => track.track!.artists)
          .expand((e) => e ?? <Artist>[]);

      final artistsWithCount = getArtistsWithCount(artists);

      final playlistsWithCount = getPlaylistsWithCount(playlists);

      return PlaybackHistoryTopState(
        tracks: tracksWithCount,
        albums: albumsWithCount,
        artists: artistsWithCount,
        playlists: playlistsWithCount,
      );
    });
  }

  List<PlaybackHistoryTrack> getTracksWithCount(List<HistoryTableData> tracks) {
    return groupBy(
      tracks,
      (track) => track.track!.id!,
    )
        .entries
        .map((entry) {
          return (count: entry.value.length, track: entry.value.first.track!);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }

  List<PlaybackHistoryAlbum> getAlbumsWithCount(
    List<AlbumSimple> albumsWithTrackAlbums,
  ) {
    return groupBy(albumsWithTrackAlbums, (album) => album.id!)
        .entries
        .map((entry) {
          return (count: entry.value.length, album: entry.value.first);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }

  List<PlaybackHistoryArtist> getArtistsWithCount(Iterable<Artist> artists) {
    return groupBy(artists, (artist) => artist.id!)
        .entries
        .map((entry) {
          return (count: entry.value.length, artist: entry.value.first);
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }

  List<PlaybackHistoryPlaylist> getPlaylistsWithCount(
    List<HistoryTableData> playlists,
  ) {
    return groupBy(playlists, (playlist) => playlist.playlist!.id!)
        .entries
        .map((entry) {
          return (
            count: entry.value.length,
            playlist: entry.value.first.playlist!,
          );
        })
        .sorted((a, b) => b.count.compareTo(a.count))
        .toList();
  }
}

final playbackHistoryTopProvider = AsyncNotifierProviderFamily<
    PlaybackHistoryTopNotifier,
    PlaybackHistoryTopState,
    HistoryDuration>(PlaybackHistoryTopNotifier.new);
