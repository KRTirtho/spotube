import 'package:riverpod/riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';

class MetadataPluginSavedAlbumNotifier
    extends PaginatedAsyncNotifier<SpotubeSimpleAlbumObject> {
  @override
  Future<SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>> fetch(
    int offset,
    int limit,
  ) async {
    return await (await metadataPlugin).user.savedAlbums(
          limit: limit,
          offset: offset,
        );
  }

  @override
  build() async {
    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }

  Future<void> addFavorite(List<SpotubeSimpleAlbumObject> albums) async {
    await update((state) async {
      (await metadataPlugin).album.save(albums.map((e) => e.id).toList());
      return state.copyWith(
        items: [...state.items, albums],
      ) as SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>;
    });

    for (final album in albums) {
      ref.invalidate(metadataPluginIsSavedAlbumProvider(album.id));
    }
  }

  Future<void> removeFavorite(List<SpotubeSimpleAlbumObject> albums) async {
    await update((state) async {
      final albumIds = albums.map((e) => e.id).toList();
      (await metadataPlugin).album.unsave(albumIds);
      return state.copyWith(
        items: state.items
            .where(
              (e) =>
                  albumIds.contains((e as SpotubeSimpleAlbumObject).id) ==
                  false,
            )
            .toList() as List<SpotubeSimpleAlbumObject>,
      ) as SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>;
    });

    for (final album in albums) {
      ref.invalidate(metadataPluginIsSavedAlbumProvider(album.id));
    }
  }
}

final metadataPluginSavedAlbumsProvider = AsyncNotifierProvider<
    MetadataPluginSavedAlbumNotifier,
    SpotubePaginationResponseObject<SpotubeSimpleAlbumObject>>(
  () => MetadataPluginSavedAlbumNotifier(),
);

final metadataPluginIsSavedAlbumProvider =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, albumId) async {
    final metadataPlugin = await ref.watch(metadataPluginProvider.future);

    return metadataPlugin!.user
        .isSavedAlbums([albumId]).then((value) => value.first);
  },
);
