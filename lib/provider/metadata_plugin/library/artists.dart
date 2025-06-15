import 'package:riverpod/riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';

class MetadataPluginSavedArtistNotifier
    extends PaginatedAsyncNotifier<SpotubeFullArtistObject> {
  @override
  Future<SpotubePaginationResponseObject<SpotubeFullArtistObject>> fetch(
    int offset,
    int limit,
  ) async {
    return await (await metadataPlugin).user.savedArtists(
          limit: limit,
          offset: offset,
        );
  }

  @override
  build() async {
    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }

  Future<void> addFavorite(List<SpotubeFullArtistObject> artists) async {
    await update((state) async {
      (await metadataPlugin).artist.save(artists.map((e) => e.id).toList());
      return state.copyWith(
        items: [...state.items, ...artists],
      );
    });

    for (final artist in artists) {
      ref.invalidate(metadataPluginIsSavedArtistProvider(artist.id));
    }
  }

  Future<void> removeFavorite(List<SpotubeFullArtistObject> artists) async {
    await update((state) async {
      final artistIds = artists.map((e) => e.id).toList();
      (await metadataPlugin).artist.unsave(artistIds);
      return state.copyWith(
        items: state.items
            .where(
              (e) => artistIds.contains((e).id) == false,
            )
            .toList(),
      );
    });

    for (final artist in artists) {
      ref.invalidate(metadataPluginIsSavedArtistProvider(artist.id));
    }
  }
}

final metadataPluginSavedArtistsProvider = AsyncNotifierProvider<
    MetadataPluginSavedArtistNotifier,
    SpotubePaginationResponseObject<SpotubeFullArtistObject>>(
  () => MetadataPluginSavedArtistNotifier(),
);

final metadataPluginIsSavedArtistProvider =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, artistId) async {
    final metadataPlugin = await ref.watch(metadataPluginProvider.future);

    return metadataPlugin!.user
        .isSavedArtists([artistId]).then((value) => value.first);
  },
);
