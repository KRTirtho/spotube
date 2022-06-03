import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = getLogger(PlaylistView);
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
    final getMe = useMemoized(() => spotify.me.get(), []);
    final meSnapshot = useFuture<User>(getMe);

    Future<List<bool>> isFollowing(User me) {
      return spotify.playlists.followedBy(playlist.id!, [me.id!]);
    }

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
                        if (auth.isLoggedIn && meSnapshot.hasData)
                          FutureBuilder<List<bool>>(
                              future: isFollowing(meSnapshot.data!),
                              builder: (context, snapshot) {
                                final isFollowing =
                                    snapshot.data?.first ?? false;

                                if (!snapshot.hasData && !snapshot.hasError) {
                                  return const SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator.adaptive(),
                                  );
                                }
                                return HeartButton(
                                  isLiked: isFollowing,
                                  icon: playlist.owner?.id != null &&
                                          meSnapshot.data?.id ==
                                              playlist.owner?.id
                                      ? Icons.delete_outline_rounded
                                      : null,
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
                        IconButton(
                          icon: const Icon(Icons.share_rounded),
                          onPressed: () {
                            final data =
                                "https://open.spotify.com/playlist/${playlist.id}";
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
                              playlistId: playlist.id,
                              userPlaylist: playlist.owner?.id != null &&
                                  playlist.owner!.id == meSnapshot.data?.id,
                            ),
                ],
              );
            }),
      ),
    );
  }
}
