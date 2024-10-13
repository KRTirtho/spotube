import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/tracks_view/track_view.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class LikedPlaylistPage extends HookConsumerWidget {
  static const name = PlaylistPage.name;

  final PlaylistSimple playlist;
  const LikedPlaylistPage({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context, ref) {
    final likedTracks = ref.watch(likedTracksProvider);
    final tracks = likedTracks.asData?.value ?? <Track>[];

    return InheritedTrackView(
      collection: playlist,
      image: "assets/liked-tracks.jpg",
      pagination: PaginationProps(
        hasNextPage: false,
        isLoading: false,
        onFetchMore: () {},
        onFetchAll: () async {
          return tracks.toList();
        },
        onRefresh: () async {
          ref.invalidate(likedTracksProvider);
        },
      ),
      title: playlist.name!,
      description: playlist.description,
      tracks: tracks,
      routePath: '/playlist/${playlist.id}',
      isLiked: false,
      shareUrl: "",
      onHeart: null,
      child: const TrackView(),
    );
  }
}
