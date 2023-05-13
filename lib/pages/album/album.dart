import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/track_table/track_collection_view.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AlbumPage extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumPage(this.album, {Key? key}) : super(key: key);

  Future<void> playPlaylist(
    List<Track> tracks,
    WidgetRef ref, {
    Track? currentTrack,
  }) async {
    final playlist = ref.read(ProxyPlaylistNotifier.provider);
    final playback = ref.read(ProxyPlaylistNotifier.notifier);
    final sortBy = ref.read(trackCollectionSortState(album.id!));
    final sortedTracks = ServiceUtils.sortTracks(tracks, sortBy);
    currentTrack ??= sortedTracks.first;
    final isPlaylistPlaying = playlist.containsTracks(tracks);
    if (!isPlaylistPlaying) {
      await playback.load(
        sortedTracks,
        initialIndex: sortedTracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playlist.activeTrack?.id) {
      await playback.jumpToTrack(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playback = ref.watch(ProxyPlaylistNotifier.notifier);

    final tracksSnapshot = useQueries.album.tracksOf(ref, album.id!);

    final albumArt = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(
              album.images,
              placeholder: ImagePlaceholder.albumArt,
            ),
        [album.images]);

    final breakpoint = useBreakpoints();

    final isAlbumPlaying = useMemoized(
      () => playlist.containsTracks(tracksSnapshot.data ?? []),
      [playback, tracksSnapshot.data],
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
              tracksSnapshot.data!
                  .map((track) =>
                      TypeConversionUtils.simpleTrack_X_Track(track, album))
                  .toList(),
              ref,
            );
          } else if (isAlbumPlaying && track != null) {
            playPlaylist(
              tracksSnapshot.data!
                  .map((track) =>
                      TypeConversionUtils.simpleTrack_X_Track(track, album))
                  .toList(),
              currentTrack: track,
              ref,
            );
          } else {
            playback
                .removeTracks(tracksSnapshot.data!.map((track) => track.id!));
          }
        }
      },
      onAddToQueue: () {
        if (tracksSnapshot.hasData && !isAlbumPlaying) {
          playback.addTracks(
            tracksSnapshot.data!
                .map((track) =>
                    TypeConversionUtils.simpleTrack_X_Track(track, album))
                .toList(),
          );
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
              tracks,
              ref,
            );
          } else if (isAlbumPlaying && track != null) {
            playPlaylist(
              tracks,
              ref,
              currentTrack: track,
            );
          } else {
            // TODO: Disable ability to stop playback from playlist/album
            // playback.stop();
          }
        }
      },
    );
  }
}
