import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/TrackCollectionView.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class AlbumView extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumView(this.album, {Key? key}) : super(key: key);

  Future<void> playPlaylist(Playback playback, List<Track> tracks,
      {Track? currentTrack}) async {
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playback.playlist?.id == album.id;
    if (!isPlaylistPlaying) {
      await playback.playPlaylist(
        CurrentPlaylist(
          tracks: tracks,
          id: album.id!,
          name: album.name!,
          thumbnail: TypeConversionUtils.image_X_UrlString(album.images),
        ),
        tracks.indexWhere((s) => s.id == currentTrack?.id),
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
    final Auth auth = ref.watch(authProvider);

    final tracksSnapshot = ref.watch(albumTracksQuery(album.id!));
    final albumSavedSnapshot =
        ref.watch(albumIsSavedForCurrentUserQuery(album.id!));

    final albumArt = useMemoized(
        () => TypeConversionUtils.image_X_UrlString(album.images),
        [album.images]);

    return TrackCollectionView(
      id: album.id!,
      isPlaying:
          playback.playlist?.id != null && playback.playlist?.id == album.id,
      title: album.name!,
      titleImage: albumArt,
      tracksSnapshot: tracksSnapshot,
      album: album,
      routePath: "/album/${album.id}",
      onPlay: ([track]) {
        if (tracksSnapshot.asData?.value != null) {
          playPlaylist(
            playback,
            tracksSnapshot.asData!.value
                .map((track) =>
                    TypeConversionUtils.simpleTrack_X_Track(track, album))
                .toList(),
            currentTrack: track,
          );
        }
      },
      onShare: () {
        Clipboard.setData(
          ClipboardData(text: "https://open.spotify.com/album/${album.id}"),
        );
      },
      heartBtn: auth.isLoggedIn
          ? albumSavedSnapshot.when(
              data: (isSaved) {
                return HeartButton(
                  isLiked: isSaved,
                  onPressed: () {
                    (isSaved
                            ? spotify.me.removeAlbums(
                                [album.id!],
                              )
                            : spotify.me.saveAlbums(
                                [album.id!],
                              ))
                        .whenComplete(() {
                      ref.refresh(
                        albumIsSavedForCurrentUserQuery(
                          album.id!,
                        ),
                      );
                      ref.refresh(currentUserAlbumsQuery);
                    });
                  },
                );
              },
              error: (error, _) => Text("Error $error"),
              loading: () => const CircularProgressIndicator())
          : null,
    );
  }
}
