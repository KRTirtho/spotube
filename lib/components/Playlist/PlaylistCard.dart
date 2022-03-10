import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistView.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistCard(this.playlist, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    bool isPlaylistPlaying = playback.currentPlaylist != null &&
        playback.currentPlaylist!.id == playlist.id;

    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      title: playlist.name!,
      imageUrl: playlist.images![0].url!,
      isPlaying: isPlaylistPlaying,
      onTap: () {
        GoRouter.of(context).push(
          "/playlist/${playlist.id}",
          extra: playlist,
        );
      },
      onPlaybuttonPressed: () async {
        if (isPlaylistPlaying) return;
        SpotifyApi spotifyApi = ref.read(spotifyProvider);

        List<Track> tracks = (playlist.id != "user-liked-tracks"
                ? await spotifyApi.playlists
                    .getTracksByPlaylistId(playlist.id!)
                    .all()
                : await spotifyApi.tracks.me.saved
                    .all()
                    .then((tracks) => tracks.map((e) => e.track!)))
            .toList();

        if (tracks.isEmpty) return;

        playback.setCurrentPlaylist = CurrentPlaylist(
          tracks: tracks,
          id: playlist.id!,
          name: playlist.name!,
          thumbnail: imageToUrlString(playlist.images),
        );
        playback.setCurrentTrack = tracks.first;
      },
    );
  }
}
