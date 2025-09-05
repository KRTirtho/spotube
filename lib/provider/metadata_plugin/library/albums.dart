import 'package:riverpod/riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
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
    await ref.watch(metadataPluginAuthenticatedProvider.future);
    return await fetch(0, 20);
  }

  Future<void> addFavorite(List<SpotubeSimpleAlbumObject> albums) async {
    if (albums.isEmpty || state.value == null) return;
    final oldState = state.value;

    state = AsyncData(
      state.value!.copyWith(
        items: [
          ...albums,
          ...state.value!.items,
        ],
      ),
    );
    try {
      await (await metadataPlugin).album.save(albums.map((e) => e.id).toList());
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
    }
  }

  Future<void> removeFavorite(List<SpotubeSimpleAlbumObject> albums) async {
    if (albums.isEmpty || state.value == null) return;

    final oldState = state.value;

    final albumIds = albums.map((e) => e.id).toList();
    state = AsyncData(
      state.value!.copyWith(
        items: state.value!.items
            .where(
              (e) => albumIds.contains((e).id) == false,
            )
            .toList(),
      ),
    );
    try {
      await (await metadataPlugin).album.unsave(albumIds);
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
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
    final savedAlbums =
        await ref.watch(metadataPluginSavedAlbumsProvider.future);
    final savedAlbumsNotifier =
        ref.read(metadataPluginSavedAlbumsProvider.notifier);
    final allSavedAlbums = savedAlbums.hasMore
        ? await savedAlbumsNotifier.fetchAll()
        : savedAlbums.items;

    return allSavedAlbums.any((element) => element.id == albumId);
  },
);
