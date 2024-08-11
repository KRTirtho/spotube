import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';
import 'package:spotube/provider/spotify/spotify.dart';

typedef UseTrackToggleLike = ({
  bool isLiked,
  Future<void> Function(Track track) toggleTrackLike,
});

UseTrackToggleLike useTrackToggleLike(Track track, WidgetRef ref) {
  final savedTracks = ref.watch(likedTracksProvider);
  final savedTracksNotifier = ref.watch(likedTracksProvider.notifier);

  final isLiked = useMemoized(
    () =>
        savedTracks.asData?.value.any((element) => element.id == track.id) ??
        false,
    [savedTracks.asData?.value, track.id],
  );

  final scrobblerNotifier = ref.read(scrobblerProvider.notifier);

  return (
    isLiked: isLiked,
    toggleTrackLike: (track) async {
      await savedTracksNotifier.toggleFavorite(track);

      if (!isLiked) {
        await scrobblerNotifier.love(track);
      } else {
        await scrobblerNotifier.unlove(track);
      }
    },
  );
}
