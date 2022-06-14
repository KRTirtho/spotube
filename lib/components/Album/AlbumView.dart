import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerTrackTile.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/simple-track-to-track.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class AlbumView extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumView(this.album, {Key? key}) : super(key: key);

  playPlaylist(Playback playback, List<Track> tracks,
      {Track? currentTrack}) async {
    currentTrack ??= tracks.first;
    var isPlaylistPlaying = playback.currentPlaylist?.id == album.id;
    if (!isPlaylistPlaying) {
      playback.setCurrentPlaylist = CurrentPlaylist(
        tracks: tracks,
        id: album.id!,
        name: album.name!,
        thumbnail: imageToUrlString(album.images),
      );
      playback.setCurrentTrack = currentTrack;
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playback.currentTrack?.id) {
      playback.setCurrentTrack = currentTrack;
    }
    await playback.startPlaying();
  }

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);

    final isPlaylistPlaying = playback.currentPlaylist?.id == album.id;
    final SpotifyApi spotify = ref.watch(spotifyProvider);
    final Auth auth = ref.watch(authProvider);

    final tracksSnapshot = ref.watch(albumTracksQuery(album.id!));
    final albumSavedSnapshot =
        ref.watch(albumIsSavedForCurrentUserQuery(album.id!));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            PageWindowTitleBar(
              leading: Row(
                children: [
                  // nav back
                  const BackButton(),
                  // heart playlist
                  if (auth.isLoggedIn)
                    albumSavedSnapshot.when(
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
                        loading: () => const CircularProgressIndicator()),
                  // play playlist
                  IconButton(
                    icon: Icon(
                      isPlaylistPlaying
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: tracksSnapshot.asData?.value != null
                        ? () => playPlaylist(
                              playback,
                              tracksSnapshot.asData!.value.map((trackSmp) {
                                return simpleTrackToTrack(trackSmp, album);
                              }).toList(),
                            )
                        : null,
                  )
                ],
              ),
            ),
            Center(
              child: Text(album.name!,
                  style: Theme.of(context).textTheme.headline4),
            ),
            tracksSnapshot.when(
              data: (data) {
                List<Track> tracks = data.map((trackSmp) {
                  return simpleTrackToTrack(trackSmp, album);
                }).toList();
                return TracksTableView(
                  tracks,
                  onTrackPlayButtonPressed: (currentTrack) => playPlaylist(
                    playback,
                    tracks,
                    currentTrack: currentTrack,
                  ),
                );
              },
              error: (error, _) => Text("Error $error"),
              loading: () => const ShimmerTrackTile(),
            ),
          ],
        ),
      ),
    );
  }
}
