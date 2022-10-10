import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistCard(this.playlist, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    bool isPlaylistPlaying =
        playback.playlist != null && playback.playlist!.id == playlist.id;

    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      title: playlist.name!,
      imageUrl: TypeConversionUtils.image_X_UrlString(
        playlist.images,
        placeholder: ImagePlaceholder.collection,
      ),
      isPlaying: isPlaylistPlaying && playback.isPlaying,
      isLoading: playback.status == PlaybackStatus.loading && isPlaylistPlaying,
      onTap: () {
        ServiceUtils.navigate(
          context,
          "/playlist/${playlist.id}",
          extra: playlist,
        );
      },
      onPlaybuttonPressed: () async {
        if (isPlaylistPlaying && playback.isPlaying) {
          return playback.pause();
        } else if (isPlaylistPlaying && !playback.isPlaying) {
          return playback.resume();
        }
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

        await playback.playPlaylist(
          CurrentPlaylist(
            tracks: tracks,
            id: playlist.id!,
            name: playlist.name!,
            thumbnail: TypeConversionUtils.image_X_UrlString(
              playlist.images,
              placeholder: ImagePlaceholder.collection,
            ),
          ),
        );
      },
    );
  }
}
