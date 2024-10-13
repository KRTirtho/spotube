import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class BlackListNotifier extends AsyncNotifier<List<BlacklistTableData>> {
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final subscription = database
        .select(database.blacklistTable)
        .watch()
        .listen((event) => state = AsyncData(event));

    ref.onDispose(() {
      subscription.cancel();
    });

    return await database.select(database.blacklistTable).get();
  }

  AppDatabase get _database => ref.read(databaseProvider);

  Future<void> add(BlacklistTableCompanion element) async {
    _database.into(_database.blacklistTable).insert(element);
  }

  Future<void> remove(String elementId) async {
    await (_database.delete(_database.blacklistTable)
          ..where((tbl) => tbl.elementId.equals(elementId)))
        .go();
  }

  bool contains(TrackSimple track) {
    final containsTrack =
        state.asData?.value.any((element) => element.elementId == track.id) ??
            false;

    final containsTrackArtists = track.artists?.any(
          (artist) =>
              state.asData?.value.any((el) => el.elementId == artist.id) ??
              false,
        ) ??
        false;

    return containsTrack || containsTrackArtists;
  }

  bool containsArtist(ArtistSimple artist) {
    return state.asData?.value
            .any((element) => element.elementId == artist.id) ??
        false;
  }

  /// Filters the non blacklisted tracks from the given [tracks]
  Iterable<TrackSimple> filter(Iterable<TrackSimple> tracks) {
    return tracks.whereNot(contains).toList();
  }

  CurrentPlaylist filterPlaylist(CurrentPlaylist playlist) {
    return CurrentPlaylist(
      id: playlist.id,
      name: playlist.name,
      thumbnail: playlist.thumbnail,
      tracks: playlist.tracks.where((track) => !contains(track)).toList(),
    );
  }
}

final blacklistProvider =
    AsyncNotifierProvider<BlackListNotifier, List<BlacklistTableData>>(
  () => BlackListNotifier(),
);
