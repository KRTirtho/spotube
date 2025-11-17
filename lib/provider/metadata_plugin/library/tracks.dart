import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';
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

    await ref.watch(metadataPluginAuthenticatedProvider.future);
    return await fetch(0, 20);
  }

  Future<void> addFavorite(List<SpotubeTrackObject> tracks) async {
    if (state.value == null) {
      return;
    }

    final oldState = state.value;
    state = AsyncData(
      state.value!.copyWith(
        items: [
          ...tracks.whereType<SpotubeFullTrackObject>(),
          ...state.value!.items
        ],
      ),
    );

    try {
      await (await metadataPlugin).track.save(tracks.map((e) => e.id).toList());
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
    }
  }

  Future<void> removeFavorite(List<SpotubeTrackObject> tracks) async {
    if (state.value == null) {
      return;
    }

    final oldState = state.value;
    state = AsyncData(
      state.value!.copyWith(
        items: state.value!.items
            .where(
              (savedTrack) => !tracks.any((track) => track.id == savedTrack.id),
            )
            .toList(),
      ),
    );

    try {
      await (await metadataPlugin)
          .track
          .unsave(tracks.map((e) => e.id).toList());
    } catch (e) {
      state = AsyncData(oldState!);
      rethrow;
    }
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
    final savedTracks =
        await ref.watch(metadataPluginSavedTracksProvider.future);
    final allSavedTracks = savedTracks.hasMore
        ? await ref.read(metadataPluginSavedTracksProvider.notifier).fetchAll()
        : savedTracks.items;

    return allSavedTracks.any((track) => track.id == trackId);
  },
);
