import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/tracks_view/track_view.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/services/queries/queries.dart';

class LikedPlaylistPage extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const LikedPlaylistPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final likedTracks = useQueries.playlist.likedTracksQuery(ref);
    final tracks = likedTracks.data ?? <Track>[];

    return InheritedTrackView(
      collectionId: playlist.id!,
      image: "assets/liked-tracks.jpg",
      pagination: PaginationProps(
        hasNextPage: false,
        isLoading: false,
        onFetchMore: () {},
        onFetchAll: () async {
          return tracks.toList();
        },
        onRefresh: () async {
          await likedTracks.refresh();
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
