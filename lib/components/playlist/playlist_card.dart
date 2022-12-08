import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
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
