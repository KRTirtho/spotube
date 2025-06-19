import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
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

  bool contains(SpotubeTrackObject track) {
    final containsTrack =
        state.asData?.value.any((element) => element.elementId == track.id) ??
            false;

    final containsTrackArtists = track.artists.any(
      (artist) =>
          state.asData?.value.any((el) => el.elementId == artist.id) ?? false,
    );

    return containsTrack || containsTrackArtists;
  }

  bool containsArtist(String artistId) {
    return state.asData?.value
            .any((element) => element.elementId == artistId) ??
        false;
  }

  /// Filters the non blacklisted tracks from the given [tracks]
  Iterable<SpotubeTrackObject> filter(Iterable<SpotubeTrackObject> tracks) {
    return tracks.whereNot(contains).toList();
  }
}

final blacklistProvider =
    AsyncNotifierProvider<BlackListNotifier, List<BlacklistTableData>>(
  () => BlackListNotifier(),
);
