import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = createLogger(PlaylistView);
  final PlaylistSimple playlist;
  PlaylistView(this.playlist, {Key? key}) : super(key: key);

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
    final Auth auth = ref.watch(authProvider);
    SpotifyApi spotify = ref.watch(spotifyProvider);
    final isPlaylistPlaying = playback.currentPlaylist?.id != null &&
        playback.currentPlaylist?.id == playlist.id;
    final update = useForceUpdate();

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<Iterable<Track>>(
            future: playlist.id != "user-liked-tracks"
                ? spotify.playlists.getTracksByPlaylistId(playlist.id).all()
                : spotify.tracks.me.saved
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
                        if (auth.isLoggedIn)
                          FutureBuilder<List<bool>>(
                              future: spotify.me.get().then(
                                    (me) => spotify.playlists
                                        .followedBy(playlist.id!, [me.id!]),
                                  ),
                              builder: (context, snapshot) {
                                final isFollowing =
                                    snapshot.data?.first ?? false;
                                return HeartButton(
                                  isLiked: isFollowing,
                                  onPressed: () async {
                                    try {
                                      isFollowing
                                          ? spotify.playlists
                                              .unfollowPlaylist(playlist.id!)
                                          : spotify.playlists
                                              .followPlaylist(playlist.id!);
                                    } catch (e, stack) {
                                      logger.e(
                                          "FollowButton.onPressed", e, stack);
                                    } finally {
                                      update();
                                    }
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
      ),
    );
  }
}
