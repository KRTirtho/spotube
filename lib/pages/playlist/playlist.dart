import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/track_table/track_collection_view.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = getLogger(PlaylistView);
  final PlaylistSimple playlist;
  PlaylistView(this.playlist, {Key? key}) : super(key: key);

  Future<void> playPlaylist(
    PlaylistQueueNotifier playlistNotifier,
    List<Track> tracks,
    WidgetRef ref, {
    Track? currentTrack,
  }) async {
    final sortBy = ref.read(trackCollectionSortState(playlist.id!));
    final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
    currentTrack ??= sortedTracks.first;
    final isPlaylistPlaying = playlistNotifier.isPlayingPlaylist(tracks);
    if (!isPlaylistPlaying) {
      await playlistNotifier.loadAndPlay(
        sortedTracks,
        active: sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playlistNotifier.state?.activeTrack.id) {
      await playlistNotifier.playTrack(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);

    final breakpoint = useBreakpoints();

    final meSnapshot = useQueries.user.me(ref);
    final tracksSnapshot = useQueries.playlist.tracksOfQuery(ref, playlist.id!);

    final isPlaylistPlaying = useMemoized(
      () => playlistNotifier.isPlayingPlaylist(tracksSnapshot.data ?? []),
      [playlistNotifier, tracksSnapshot.data],
    );

    final titleImage = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(
              playlist.images,
              placeholder: ImagePlaceholder.collection,
            ),
        [playlist.images]);

    return TrackCollectionView(
      id: playlist.id!,
      isPlaying: isPlaylistPlaying,
      title: playlist.name!,
      titleImage: titleImage,
      tracksSnapshot: tracksSnapshot,
      description: playlist.description,
      isOwned: playlist.owner?.id != null &&
          playlist.owner!.id == meSnapshot.data?.id,
      onPlay: ([track]) {
        if (tracksSnapshot.hasData) {
          if (!isPlaylistPlaying) {
            playPlaylist(
              playlistNotifier,
              tracksSnapshot.data!,
              ref,
              currentTrack: track,
            );
          } else if (isPlaylistPlaying && track != null) {
            playPlaylist(
              playlistNotifier,
              tracksSnapshot.data!,
              ref,
              currentTrack: track,
            );
          } else {
            playlistNotifier.remove(tracksSnapshot.data!);
          }
        }
      },
      onAddToQueue: () {
        if (tracksSnapshot.hasData && !isPlaylistPlaying) {
          playlistNotifier.add(tracksSnapshot.data!);
        }
      },
      bottomSpace: breakpoint.isLessThanOrEqualTo(Breakpoints.md),
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
      heartBtn: PlaylistHeartButton(playlist: playlist),
      onShuffledPlay: ([track]) {
        final tracks = [...?tracksSnapshot.data]..shuffle();

        if (tracksSnapshot.hasData) {
          if (!isPlaylistPlaying) {
            playPlaylist(
              playlistNotifier,
              tracks,
              ref,
              currentTrack: track,
            );
          } else if (isPlaylistPlaying && track != null) {
            playPlaylist(
              playlistNotifier,
              tracks,
              ref,
              currentTrack: track,
            );
          } else {
            playlistNotifier.stop();
          }
        }
      },
    );
  }
}
