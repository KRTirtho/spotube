import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/track_table/track_collection_view.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/components/shared/playlist_shuffle_button.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = getLogger(PlaylistView);
  final PlaylistSimple playlist;
  PlaylistView(this.playlist, {Key? key}) : super(key: key);

  Future<void> playPlaylist(
    Playback playback,
    List<Track> tracks,
    WidgetRef ref, {
    Track? currentTrack,
  }) async {
    final sortBy = ref.read(trackCollectionSortState(playlist.id!));
    final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
    currentTrack ??= sortedTracks.first;
    final isPlaylistPlaying =
        playback.playlist?.id != null && playback.playlist?.id == playlist.id;
    if (!isPlaylistPlaying) {
      await playback.playPlaylist(
        CurrentPlaylist(
          tracks: sortedTracks,
          id: playlist.id!,
          name: playlist.name!,
          thumbnail: TypeConversionUtils.image_X_UrlString(
            playlist.images,
            placeholder: ImagePlaceholder.collection,
          ),
        ),
        sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playback.track?.id) {
      await playback.play(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    SpotifyApi spotify = ref.watch(spotifyProvider);
    final isPlaylistPlaying =
        playback.playlist?.id != null && playback.playlist?.id == playlist.id;

    final breakpoint = useBreakpoints();

    final meSnapshot = useQuery(job: Queries.user.me, externalData: spotify);
    final tracksSnapshot = useQuery(
      job: Queries.playlist.tracksOf(playlist.id!),
      externalData: spotify,
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
              playback,
              tracksSnapshot.data!,
              ref,
              currentTrack: track,
            );
          } else if (isPlaylistPlaying && track != null) {
            playPlaylist(
              playback,
              tracksSnapshot.data!,
              ref,
              currentTrack: track,
            );
          } else {
            playback.stop();
          }
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
      shuffleButton: PlaylistShuffleButton(onPressed: () {
        // Shuffle the tracks (create a copy of playlist)
        var tracks = [...?tracksSnapshot.data];
        tracks.shuffle();

        // If playback is playing a track then pause it
        if (playback.isPlaying) {
          playback.pause();
        }

        // Play the shuffled playlist
        playPlaylist( playback,
          tracks,
          ref,
          currentTrack: null,
        );
      }),
    );
  }
}
