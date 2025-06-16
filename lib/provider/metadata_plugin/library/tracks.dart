import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/user.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';
import 'package:spotube/provider/metadata_plugin/utils/paginated.dart';

class MetadataPluginSavedTracksNotifier
    extends AutoDisposePaginatedAsyncNotifier<SpotubeFullTrackObject> {
  MetadataPluginSavedTracksNotifier() : super();

  @override
  fetch(offset, limit) async {
    final user = await ref.read(metadataPluginUserProvider.future);

    if (user == null) {
      throw Exception(
        'User not found \n'
        'You need to be logged in to access saved tracks.',
      );
    }

    final tracks = await (await metadataPlugin).album.tracks(
          user.id,
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

    for (final track in tracks) {
      ref.invalidate(metadataPluginIsSavedTrackProvider(track.id));
    }
  }

  Future<void> removeFavorite(List<SpotubeTrackObject> tracks) async {
    await (await metadataPlugin).track.unsave(tracks.map((e) => e.id).toList());

    for (final track in tracks) {
      ref.invalidate(metadataPluginIsSavedTrackProvider(track.id));
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
    final metadataPlugin = await ref.watch(metadataPluginProvider.future);

    return metadataPlugin!.user
        .isSavedTracks([trackId]).then((value) => value.first);
  },
);
