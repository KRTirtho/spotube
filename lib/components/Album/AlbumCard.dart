import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/simple-track-to-track.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class AlbumCard extends HookConsumerWidget {
  final Album album;
  const AlbumCard(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    bool isPlaylistPlaying = playback.currentPlaylist != null &&
        playback.currentPlaylist!.id == album.id;
    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      imageUrl: imageToUrlString(album.images),
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      isPlaying: playback.currentPlaylist?.id != null &&
          playback.currentPlaylist?.id == album.id,
      title: album.name!,
      description:
          "Album • ${artistsToString<ArtistSimple>(album.artists ?? [])}",
      onTap: () {
        Navigator.of(context).push(SpotubePageRoute(
          child: AlbumView(album),
        ));
      },
      onPlaybuttonPressed: () async {
        SpotifyApi spotify = ref.read(spotifyProvider);
        if (isPlaylistPlaying) return;
        List<Track> tracks = (await spotify.albums.getTracks(album.id!).all())
            .map((track) => simpleTrackToTrack(track, album))
            .toList();
        if (tracks.isEmpty) return;

        playback.setCurrentPlaylist = CurrentPlaylist(
          tracks: tracks,
          id: album.id!,
          name: album.name!,
          thumbnail: album.images!.first.url!,
        );
        playback.setCurrentTrack = tracks.first;
      },
    );
  }
}
