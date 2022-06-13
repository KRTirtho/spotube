import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class PlaylistView extends HookConsumerWidget {
  final logger = getLogger(PlaylistView);
  final PlaylistSimple playlist;
  PlaylistView(this.playlist, {Key? key}) : super(key: key);

  playPlaylist(Playback playback, List<Track> tracks,
      {Track? currentTrack}) async {
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playback.currentPlaylist?.id != null &&
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

    final meSnapshot = ref.watch(currentUserQuery);
    final tracksSnapshot = ref.watch(playlistTracksQuery(playlist.id!));

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
                    meSnapshot.when(
                      data: (me) {
                        final query = playlistIsFollowedQuery(jsonEncode(
                            {"playlistId": playlist.id, "userId": me.id!}));
                        final followingSnapshot = ref.watch(query);

                        return followingSnapshot.when(
                          data: (isFollowing) {
                            return HeartButton(
                              isLiked: isFollowing,
                              icon: playlist.owner?.id != null &&
                                      me.id == playlist.owner?.id
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
                                  logger.e("FollowButton.onPressed", e, stack);
                                } finally {
                                  ref.refresh(query);
                                  ref.refresh(currentUserPlaylistsQuery);
                                }
                              },
                            );
                          },
                          error: (error, _) => Text("Error $error"),
                          loading: () => const CircularProgressIndicator(),
                        );
                      },
                      error: (error, _) => Text("Error $error"),
                      loading: () => const CircularProgressIndicator(),
                    ),

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
                    onPressed: tracksSnapshot.asData?.value != null
                        ? () => playPlaylist(
                              playback,
                              tracksSnapshot.asData!.value,
                            )
                        : null,
                  )
                ],
              ),
            ),
            Center(
              child: Text(playlist.name!,
                  style: Theme.of(context).textTheme.headline4),
            ),
            tracksSnapshot.when(
              data: (tracks) {
                return TracksTableView(
                  tracks,
                  onTrackPlayButtonPressed: (currentTrack) => playPlaylist(
                    playback,
                    tracks,
                    currentTrack: currentTrack,
                  ),
                  playlistId: playlist.id,
                  userPlaylist: playlist.owner?.id != null &&
                      playlist.owner!.id == meSnapshot.asData?.value.id,
                );
              },
              error: (error, _) => Text("Error $error"),
              loading: () => const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
