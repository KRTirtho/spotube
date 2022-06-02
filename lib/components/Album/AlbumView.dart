import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/simple-track-to-track.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

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

    final update = useForceUpdate();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Iterable<TrackSimple>>(
            future: spotify.albums.getTracks(album.id!).all(),
            builder: (context, snapshot) {
              List<Track> tracks = snapshot.data?.map((trackSmp) {
                    return simpleTrackToTrack(trackSmp, album);
                  }).toList() ??
                  [];
              return Column(
                children: [
                  PageWindowTitleBar(
                    leading: Row(
                      children: [
                        // nav back
                        const BackButton(),
                        // heart playlist
                        if (auth.isLoggedIn)
                          FutureBuilder<List<bool>>(
                              future: spotify.me.isSavedAlbums([album.id!]),
                              builder: (context, snapshot) {
                                final isSaved = snapshot.data?.first == true;
                                if (!snapshot.hasData && !snapshot.hasError) {
                                  return const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
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
                                        .then((_) => update());
                                  },
                                );
                              }),
                        // play playlist
                        IconButton(
                          icon: Icon(
                            isPlaylistPlaying
                                ? Icons.stop_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          onPressed: snapshot.hasData
                              ? () => playPlaylist(playback, tracks)
                              : null,
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Text(album.name!,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  snapshot.hasError
                      ? const Center(child: Text("Error occurred"))
                      : !snapshot.hasData
                          ? const Expanded(
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            )
                          : TracksTableView(
                              tracks,
                              onTrackPlayButtonPressed: (currentTrack) =>
                                  playPlaylist(
                                playback,
                                tracks,
                                currentTrack: currentTrack,
                              ),
                            ),
                ],
              );
            }),
      ),
    );
  }
}
