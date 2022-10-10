import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AlbumCard extends HookConsumerWidget {
  final Album album;
  const AlbumCard(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    bool isPlaylistPlaying =
        playback.playlist != null && playback.playlist!.id == album.id;
    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      imageUrl: TypeConversionUtils.image_X_UrlString(
        album.images,
        placeholder: ImagePlaceholder.collection,
      ),
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      isPlaying: isPlaylistPlaying && playback.isPlaying,
      isLoading: playback.status == PlaybackStatus.loading &&
          playback.playlist?.id == album.id,
      title: album.name!,
      description:
          "Album • ${TypeConversionUtils.artists_X_String<ArtistSimple>(album.artists ?? [])}",
      onTap: () {
        ServiceUtils.navigate(context, "/album/${album.id}", extra: album);
      },
      onPlaybuttonPressed: () async {
        SpotifyApi spotify = ref.read(spotifyProvider);
        if (isPlaylistPlaying && playback.isPlaying) {
          return playback.pause();
        } else if (isPlaylistPlaying && !playback.isPlaying) {
          return playback.resume();
        }
        List<Track> tracks = (await spotify.albums.getTracks(album.id!).all())
            .map((track) =>
                TypeConversionUtils.simpleTrack_X_Track(track, album))
            .toList();
        if (tracks.isEmpty) return;

        await playback.playPlaylist(CurrentPlaylist(
          tracks: tracks,
          id: album.id!,
          name: album.name!,
          thumbnail: album.images!.first.url!,
        ));
      },
    );
  }
}
