import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/library/playlists.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/services/metadata/errors/exceptions.dart';
import 'package:spotube/services/metadata/metadata.dart';

class MetadataPluginPlaylistNotifier
    extends AutoDisposeFamilyAsyncNotifier<SpotubeFullPlaylistObject, String> {
  Future<MetadataPlugin> get metadataPlugin async {
    final metadataPlugin = await ref.read(metadataPluginProvider.future);

    if (metadataPlugin == null) {
      throw MetadataPluginException.noDefaultMetadataPlugin();
    }

    return metadataPlugin;
  }

  @override
  build(playlistId) async {
    ref.cacheFor();

    return (await metadataPlugin).playlist.getPlaylist(playlistId);
  }

  Future<void> create({
    required String name,
    String? description,
    bool? public,
    bool? collaborative,
    void Function(dynamic error)? onError,
  }) async {
    final userId = await ref
        .read(metadataPluginUserProvider.selectAsync((data) => data?.id));
    if (userId == null) {
      throw Exception('User ID is not available. Please log in first.');
    }
    state = const AsyncValue.loading();
    try {
      final playlist = await (await metadataPlugin).playlist.create(
            userId,
            name: name,
            description: description,
            public: public,
            collaborative: collaborative,
          );
      if (playlist != null) {
        state = AsyncValue.data(playlist);
      }
      ref.invalidate(metadataPluginSavedPlaylistsProvider);
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }

  Future<void> modify({
    String? name,
    String? description,
    bool? public,
    bool? collaborative,
    void Function(dynamic error)? onError,
  }) async {
    try {
      if (name == null &&
          description == null &&
          public == null &&
          collaborative == null) {
        throw Exception('No modifications provided.');
      }
      await (await metadataPlugin).playlist.update(
            arg,
            name: name,
            description: description,
            public: public,
            collaborative: collaborative,
          );
      ref.invalidateSelf();
    } on Exception catch (e) {
      onError?.call(e);
      rethrow;
    }
  }

  Future<void> addTracks(List<String> trackIds,
      [void Function(dynamic error)? onError]) async {
    if (state.value == null) return;

    try {
      await ref
          .read(metadataPluginSavedPlaylistsProvider.notifier)
          .addTracks(arg, trackIds);
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }

  Future<void> removeTracks(List<String> trackIds,
      [void Function(dynamic error)? onError]) async {
    try {
      if (state.value == null) return;

      await ref
          .read(metadataPluginSavedPlaylistsProvider.notifier)
          .removeTracks(arg, trackIds);
    } catch (e) {
      onError?.call(e);
      rethrow;
    }
  }

  Future<void> delete() async {
    if (state.value == null) return;
    final userId = await ref
        .read(metadataPluginUserProvider.selectAsync((data) => data?.id));
    if (userId == null || userId != state.value!.owner.id) {
      throw Exception('You can only delete your own playlists.');
    }

    await ref.read(metadataPluginSavedPlaylistsProvider.notifier).delete(arg);
  }
}

final metadataPluginPlaylistProvider = AutoDisposeAsyncNotifierProviderFamily<
    MetadataPluginPlaylistNotifier, SpotubeFullPlaylistObject, String>(
  () => MetadataPluginPlaylistNotifier(),
);
