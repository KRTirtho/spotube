import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/library/tracks.dart';

typedef UseTrackToggleLike = ({
  bool isLiked,
  bool isLoading,
  Future<void> Function(SpotubeTrackObject track) toggleTrackLike,
});

UseTrackToggleLike useTrackToggleLike(SpotubeTrackObject track, WidgetRef ref) {
  final savedTracksNotifier =
      ref.watch(metadataPluginSavedTracksProvider.notifier);

  final isSavedTrack = ref.watch(metadataPluginIsSavedTrackProvider(track.id));

  return (
    isLiked: isSavedTrack.asData?.value ?? false,
    isLoading: isSavedTrack.isLoading,
    toggleTrackLike: (track) async {
      final isLikedTrack = await ref.read(
        metadataPluginIsSavedTrackProvider(track.id).future,
      );

      if (isLikedTrack) {
        await savedTracksNotifier.removeFavorite([track]);
      } else {
        await savedTracksNotifier.addFavorite([track]);
      }
    },
  );
}
