import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/track_table/track_collection_view/track_collection_heading.dart';
import 'package:spotube/components/shared/track_table/track_collection_view/track_collection_view.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = getLogger(PlaylistView);
  final PlaylistSimple playlistSimple;
  PlaylistView(this.playlistSimple, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final proxyPlaylist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);

    final mediaQuery = MediaQuery.of(context);

    final meSnapshot = useQueries.user.me(ref);

    final playlistQuery = useQueries.playlist.byId(ref, playlistSimple.id!);
    final playlist = playlistQuery.data ?? playlistSimple;

    final playlistTrackSnapshot =
        useQueries.playlist.tracksOfQuery(ref, playlist.id!);
    final likedTracksSnapshot = useQueries.playlist.likedTracksQuery(ref);
    final tracksSnapshot = playlist.id! == "user-liked-tracks"
        ? likedTracksSnapshot
        : playlistTrackSnapshot;

    final isPlaylistPlaying = useMemoized(
      () => proxyPlaylist.collections.contains(playlist.id!),
      [proxyPlaylist, playlist],
    );

    final titleImage = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(
              playlist.images,
              placeholder: ImagePlaceholder.collection,
            ),
        [playlist.images]);

    final playlistTrackPlaying = useMemoized(
      () =>
          tracksSnapshot.data
                  ?.any((s) => s.id! == proxyPlaylist.activeTrack?.id!) ==
              true &&
          proxyPlaylist.activeTrack is SourcedTrack,
      [proxyPlaylist.activeTrack, tracksSnapshot.data],
    );

    final playPlaylist = useCallback((
      List<Track> tracks,
      WidgetRef ref, {
      Track? currentTrack,
    }) async {
      final playback = ref.read(ProxyPlaylistNotifier.notifier);
      final sortBy = ref.read(trackCollectionSortState(playlist.id!));
      final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
      currentTrack ??= sortedTracks.first;
      final isPlaylistPlaying = proxyPlaylist.containsTracks(tracks);
      if (!isPlaylistPlaying) {
        playback.addCollection(playlist.id!); // for enabling loading indicator
        await playback.load(
          sortedTracks,
          initialIndex:
              sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
          autoPlay: true,
        );
        playback.addCollection(playlist.id!);
      } else if (isPlaylistPlaying &&
          currentTrack.id != null &&
          currentTrack.id != proxyPlaylist.activeTrack?.id) {
        await playback.jumpToTrack(currentTrack);
      }
    }, [proxyPlaylist, playlist]);

    final ownPlaylist =
        playlist.owner?.id != null && playlist.owner?.id == meSnapshot.data?.id;

    return TrackCollectionView(
      id: playlist.id!,
      playingState: isPlaylistPlaying && playlistTrackPlaying
          ? PlayButtonState.playing
          : isPlaylistPlaying && !playlistTrackPlaying
              ? PlayButtonState.loading
              : PlayButtonState.notPlaying,
      title: playlist.name!,
      titleImage: titleImage,
      tracksSnapshot: tracksSnapshot,
      description: playlist.description,
      isOwned: ownPlaylist,
      onPlay: ([track]) async {
        if (tracksSnapshot.hasData) {
          if (!isPlaylistPlaying || (isPlaylistPlaying && track != null)) {
            await playPlaylist(
              tracksSnapshot.data!,
              ref,
              currentTrack: track,
            );
          } else {
            await playlistNotifier
                .removeTracks(tracksSnapshot.data!.map((e) => e.id!));
          }
        }
      },
      onAddToQueue: () {
        if (tracksSnapshot.hasData && !isPlaylistPlaying) {
          playlistNotifier.addTracks(tracksSnapshot.data!);
          playlistNotifier.addCollection(playlist.id!);
        }
      },
      bottomSpace: mediaQuery.mdAndDown,
      showShare: playlist.id != "user-liked-tracks",
      routePath: "/playlist/${playlist.id}",
      onShare: () {
        final data = "https://open.spotify.com/playlist/${playlist.id}";
        Clipboard.setData(
          ClipboardData(text: data),
        ).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              width: 300,
              behavior: SnackBarBehavior.floating,
              content: Text(
                "Copied $data to clipboard",
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
      },
      heartBtn: PlaylistHeartButton(
        playlist: playlist,
        icon: ownPlaylist ? SpotubeIcons.trash : null,
        onData: (data) {
          GoRouter.of(context).pop();
        },
      ),
      onShuffledPlay: ([track]) {
        final tracks = [...?tracksSnapshot.data]..shuffle();

        if (tracksSnapshot.hasData) {
          if (!isPlaylistPlaying) {
            playPlaylist(
              tracks,
              ref,
              currentTrack: track,
            );
          } else if (isPlaylistPlaying && track != null) {
            playPlaylist(
              tracks,
              ref,
              currentTrack: track,
            );
          } else {
            // TODO: Remove the ability to stop the playlist
            // playlistNotifier.stop();
          }
        }
      },
    );
  }
}
