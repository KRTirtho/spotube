import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/tracks/playlist.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';
import 'package:spotube/services/metadata/endpoints/error.dart';

class FavoritePlaylistsNotifier
    extends PaginatedAsyncNotifier<SpotubeSimplePlaylistObject> {
  FavoritePlaylistsNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final playlists = await (await metadataPlugin)
        ?.user
        .savedPlaylists(limit: limit, offset: offset);

    return playlists!;
  }

  @override
  build() async {
    ref.watch(metadataPluginProvider);
    final playlists = await fetch(0, 20);

    return playlists;
  }

  void updatePlaylist(SpotubeSimplePlaylistObject playlist) {
    if (state.value == null) return;

    if (state.value!.items.none((e) => e.id == playlist.id)) return;

    state = AsyncData(
      state.value!.copyWith(
        items: state.value!.items
            .map((element) => element.id == playlist.id ? playlist : element)
            .toList() as List<SpotubeSimplePlaylistObject>,
      ) as SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>,
    );
  }

  Future<void> addFavorite(SpotubeSimplePlaylistObject playlist) async {
    await update((state) async {
      (await metadataPlugin)!.playlist.save(playlist.id);
      return state.copyWith(
        items: [...state.items, playlist],
      ) as SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>;
    });

    ref.invalidate(metadataPluginIsSavedPlaylistProvider(playlist.id));
  }

  Future<void> removeFavorite(SpotubeSimplePlaylistObject playlist) async {
    await update((state) async {
      (await metadataPlugin)!.playlist.unsave(playlist.id);
      return state.copyWith(
        items: state.items
            .where((e) => (e as SpotubeSimplePlaylistObject).id != playlist.id)
            .toList() as List<SpotubeSimplePlaylistObject>,
      ) as SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>;
    });

    ref.invalidate(metadataPluginIsSavedPlaylistProvider(playlist.id));
  }

  Future<void> delete(SpotubeSimplePlaylistObject playlist) async {
    await update((state) async {
      (await metadataPlugin)!.playlist.deletePlaylist(playlist.id);
      return state.copyWith(
        items: state.items
            .where((e) => (e as SpotubeSimplePlaylistObject).id != playlist.id)
            .toList() as List<SpotubeSimplePlaylistObject>,
      ) as SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>;
    });

    ref.invalidate(metadataPluginIsSavedPlaylistProvider(playlist.id));
    ref.invalidate(metadataPluginPlaylistTracksProvider(playlist.id));
  }

  Future<void> addTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    await (await metadataPlugin)!
        .playlist
        .addTracks(playlistId, trackIds: trackIds);

    ref.invalidate(metadataPluginPlaylistTracksProvider(playlistId));
  }

  Future<void> removeTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    await (await metadataPlugin)!
        .playlist
        .removeTracks(playlistId, trackIds: trackIds);

    ref.invalidate(metadataPluginPlaylistTracksProvider(playlistId));
  }
}

final metadataPluginSavedPlaylistsProvider = AsyncNotifierProvider<
    FavoritePlaylistsNotifier,
    SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>>(
  () => FavoritePlaylistsNotifier(),
);

final metadataPluginIsSavedPlaylistProvider =
    FutureProvider.family<bool, String>(
  (ref, id) async {
    final plugin = await ref.watch(metadataPluginProvider.future);

    if (plugin == null) {
      throw MetadataPluginException.noDefaultPlugin(
        "Failed to get metadata plugin",
      );
    }

    final follows = await plugin.user.isSavedPlaylist(id);

    return follows;
  },
);
