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
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/provider/spotify_provider.dart';

class AlbumPage extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumPage(this.album, {Key? key}) : super(key: key);

  Future<void> playPlaylist(
    PlaylistQueueNotifier playback,
    List<Track> tracks,
    WidgetRef ref, {
    Track? currentTrack,
  }) async {
    final playlist = ref.read(PlaylistQueueNotifier.provider);
    final sortBy = ref.read(trackCollectionSortState(album.id!));
    final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
    currentTrack ??= sortedTracks.first;
    final isPlaylistPlaying = playback.isPlayingPlaylist(tracks);
    if (!isPlaylistPlaying) {
      playback.load(
        sortedTracks,
        active: sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
      );
      await playback.play();
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playlist?.activeTrack.id) {
      await playback.playAt(
        sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(PlaylistQueueNotifier.provider);
    final playback = ref.watch(PlaylistQueueNotifier.notifier);

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

    final isAlbumPlaying = useMemoized(
      () => playback.isPlayingPlaylist(tracksSnapshot.data ?? []),
      [tracksSnapshot.data],
    );
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
      onShuffledPlay: ([track]) {
        // Shuffle the tracks (create a copy of playlist)
        if (tracksSnapshot.hasData) {
          final tracks = tracksSnapshot.data!
              .map((track) =>
                  TypeConversionUtils.simpleTrack_X_Track(track, album))
              .toList()
            ..shuffle();
          if (!isAlbumPlaying) {
            playPlaylist(
              playback,
              tracks,
              ref,
            );
          } else if (isAlbumPlaying && track != null) {
            playPlaylist(
              playback,
              tracks,
              ref,
              currentTrack: track,
            );
          } else {
            playback.stop();
          }
        }
      },
    );
  }
}
