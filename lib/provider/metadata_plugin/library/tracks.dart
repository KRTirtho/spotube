import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';

class MetadataPluginSavedTracksNotifier
    extends AutoDisposePaginatedAsyncNotifier<SpotubeFullTrackObject> {
  MetadataPluginSavedTracksNotifier() : super();

  @override
  fetch(offset, limit) async {
    final tracks = await (await metadataPlugin).user.savedTracks(
          offset: offset,
          limit: limit,
        );

    return tracks;
  }

  @override
  build() async {
    ref.cacheFor();

    ref.watch(metadataPluginProvider);
    return await fetch(0, 20);
  }

  Future<void> addFavorite(List<SpotubeTrackObject> tracks) async {
    await (await metadataPlugin).track.save(tracks.map((e) => e.id).toList());

    ref.invalidateSelf();
  }

  Future<void> removeFavorite(List<SpotubeTrackObject> tracks) async {
    await (await metadataPlugin).track.unsave(tracks.map((e) => e.id).toList());

    ref.invalidateSelf();
  }
}

final metadataPluginSavedTracksProvider = AutoDisposeAsyncNotifierProvider<
    MetadataPluginSavedTracksNotifier,
    SpotubePaginationResponseObject<SpotubeFullTrackObject>>(
  () => MetadataPluginSavedTracksNotifier(),
);

final metadataPluginIsSavedTrackProvider =
    FutureProvider.autoDispose.family<bool, String>(
  (ref, trackId) async {
    await ref.watch(metadataPluginSavedTracksProvider.future);
    final allSavedTracks =
        await ref.read(metadataPluginSavedTracksProvider.notifier).fetchAll();

    return allSavedTracks.any((track) => track.id == trackId);
  },
);
