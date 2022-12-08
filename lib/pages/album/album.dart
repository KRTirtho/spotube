import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/track_table/track_collection_view.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/components/shared/playlist_shuffle_button.dart';

class AlbumPage extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumPage(this.album, {Key? key}) : super(key: key);

  Future<void> playPlaylist(
    Playback playback,
    List<Track> tracks,
    WidgetRef ref, {
    Track? currentTrack,
  }) async {
    final sortBy = ref.read(trackCollectionSortState(album.id!));
    final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
    currentTrack ??= sortedTracks.first;
    final isPlaylistPlaying = playback.playlist?.id == album.id;
    if (!isPlaylistPlaying) {
      await playback.playPlaylist(
        CurrentPlaylist(
          tracks: sortedTracks,
          id: album.id!,
          name: album.name!,
          thumbnail: TypeConversionUtils.image_X_UrlString(
            album.images,
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

    final SpotifyApi spotify = ref.watch(spotifyProvider);

    final tracksSnapshot = useQuery(
      job: Queries.album.tracksOf(album.id!),
      externalData: spotify,
    );

    final albumArt = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(
              album.images,
              placeholder: ImagePlaceholder.albumArt,
            ),
        [album.images]);

    final breakpoint = useBreakpoints();

    final isAlbumPlaying =
        playback.playlist?.id != null && playback.playlist?.id == album.id;
    return TrackCollectionView(
      id: album.id!,
      isPlaying: isAlbumPlaying,
      title: album.name!,
      titleImage: albumArt,
      tracksSnapshot: tracksSnapshot,
      album: album,
      routePath: "/album/${album.id}",
      bottomSpace: breakpoint.isLessThanOrEqualTo(Breakpoints.md),
      onPlay: ([track]) {
        if (tracksSnapshot.hasData) {
          if (!isAlbumPlaying) {
            playPlaylist(
              playback,
              tracksSnapshot.data!
                  .map((track) =>
                      TypeConversionUtils.simpleTrack_X_Track(track, album))
                  .toList(),
              ref,
            );
          } else if (isAlbumPlaying && track != null) {
            playPlaylist(
              playback,
              tracksSnapshot.data!
                  .map((track) =>
                      TypeConversionUtils.simpleTrack_X_Track(track, album))
                  .toList(),
              currentTrack: track,
              ref,
            );
          } else {
            playback.stop();
          }
        }
      },
      onShare: () {
        Clipboard.setData(
          ClipboardData(text: "https://open.spotify.com/album/${album.id}"),
        );
      },
      heartBtn: AlbumHeartButton(album: album),
      shuffleButton: PlaylistShuffleButton(onPressed: () {
        var albumTracks = tracksSnapshot.data!
            .map((track) =>
            TypeConversionUtils.simpleTrack_X_Track(track, album))
            .toList();
        // Shuffle the tracks (create a copy of playlist)
        var tracks = [...albumTracks];
        tracks.shuffle();

        // If playback is playing a track then pause it
        if (playback.isPlaying) {
          playback.pause();
        }

        // Play the shuffled playlist
        playPlaylist( playback,
          tracks,
          ref,
        );
      }),
    );
  }
}
