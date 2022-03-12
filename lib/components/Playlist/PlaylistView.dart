import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends ConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistView(this.playlist, {Key? key}) : super(key: key);

  playPlaylist(Playback playback, List<Track> tracks,
      {Track? currentTrack}) async {
    currentTrack ??= tracks.first;
    var isPlaylistPlaying = playback.currentPlaylist?.id != null &&
        playback.currentPlaylist?.id == playlist.id;
    if (!isPlaylistPlaying) {
      playback.setCurrentPlaylist = CurrentPlaylist(
        tracks: tracks,
        id: playlist.id!,
        name: playlist.name!,
        thumbnail: imageToUrlString(playlist.images),
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
    SpotifyApi spotifyApi = ref.watch(spotifyProvider);
    var isPlaylistPlaying = playback.currentPlaylist?.id != null &&
        playback.currentPlaylist?.id == playlist.id;
    return Scaffold(
      body: FutureBuilder<Iterable<Track>>(
          future: playlist.id != "user-liked-tracks"
              ? spotifyApi.playlists.getTracksByPlaylistId(playlist.id).all()
              : spotifyApi.tracks.me.saved
                  .all()
                  .then((tracks) => tracks.map((e) => e.track!)),
          builder: (context, snapshot) {
            List<Track> tracks = snapshot.data?.toList() ?? [];
            return Column(
              children: [
                PageWindowTitleBar(
                  leading: Row(
                    children: [
                      // nav back
                      const BackButton(),
                      // heart playlist
                      IconButton(
                        icon: const Icon(Icons.favorite_outline_rounded),
                        onPressed: () {},
                      ),
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
                  child: Text(playlist.name!,
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
    );
  }
}
