import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/tracks/playlist.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';

class MetadataPluginSavedPlaylistsNotifier
    extends PaginatedAsyncNotifier<SpotubeSimplePlaylistObject> {
  MetadataPluginSavedPlaylistsNotifier() : super();

  @override
  fetch(int offset, int limit) async {
    final playlists = await (await metadataPlugin)
        .user
        .savedPlaylists(limit: limit, offset: offset);

    return playlists;
  }

  @override
  build() async {
    await ref.watch(metadataPluginAuthenticatedProvider.future);

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
            .toList(),
      ),
    );
  }

  Future<void> addFavorite(SpotubeSimplePlaylistObject playlist) async {
    if (state.value == null) return;

    final oldState = state.value;

    state = AsyncData(
      state.value!.copyWith(
        items: [
          playlist,
          ...state.value!.items,
        ],
      ),
    );

    try {
      await (await metadataPlugin).playlist.save(playlist.id);
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
    }
  }

  Future<void> removeFavorite(SpotubeSimplePlaylistObject playlist) async {
    if (state.value == null) return;

    final oldState = state.value;
    state = AsyncData(
      state.value!.copyWith(
        items: state.value!.items.where((e) => (e).id != playlist.id).toList(),
      ),
    );

    try {
      await (await metadataPlugin).playlist.unsave(playlist.id);
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
    }
  }

  Future<void> delete(String playlistId) async {
    if (state.value == null) return;
    final oldState = state;
    try {
      state = const AsyncLoading();
      await (await metadataPlugin).playlist.deletePlaylist(playlistId);
      ref.invalidateSelf();
      ref.invalidate(metadataPluginIsSavedPlaylistProvider(playlistId));
      ref.invalidate(metadataPluginPlaylistTracksProvider(playlistId));
    } catch (e) {
      state = oldState;
      rethrow;
    }
  }

  Future<void> addTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    await (await metadataPlugin)
        .playlist
        .addTracks(playlistId, trackIds: trackIds);

    ref.invalidate(metadataPluginPlaylistTracksProvider(playlistId));
  }

  Future<void> removeTracks(String playlistId, List<String> trackIds) async {
    if (state.value == null) return;

    await (await metadataPlugin)
        .playlist
        .removeTracks(playlistId, trackIds: trackIds);

    ref.invalidate(metadataPluginPlaylistTracksProvider(playlistId));
  }
}

final metadataPluginSavedPlaylistsProvider = AsyncNotifierProvider<
    MetadataPluginSavedPlaylistsNotifier,
    SpotubePaginationResponseObject<SpotubeSimplePlaylistObject>>(
  () => MetadataPluginSavedPlaylistsNotifier(),
);

final metadataPluginIsSavedPlaylistProvider =
    FutureProvider.family<bool, String>(
  (ref, id) async {
    final plugin = await ref.watch(metadataPluginProvider.future);

    if (plugin == null) {
      throw MetadataPluginException.noDefaultMetadataPlugin();
    }

    final savedPlaylists =
        await ref.watch(metadataPluginSavedPlaylistsProvider.future);

    final savedPlaylistsNotifier =
        ref.read(metadataPluginSavedPlaylistsProvider.notifier);

    final allSavedPlaylists = savedPlaylists.hasMore
        ? await savedPlaylistsNotifier.fetchAll()
        : savedPlaylists.items;

    return allSavedPlaylists.any((element) => element.id == id);
  },
);
