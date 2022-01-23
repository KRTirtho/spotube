import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/PlaybuttonCard.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/provider/Playback.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard(this.album, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Playback playback = context.watch<Playback>();

    return PlaybuttonCard(
      imageUrl: album.images!.first.url!,
      isPlaying: playback.currentPlaylist?.id != null &&
          playback.currentPlaylist?.id == album.id,
      title: album.name!,
      description:
          "Alubm • ${artistsToString<ArtistSimple>(album.artists ?? [])}",
      onTap: () {},
      onPlaybuttonPressed: () => {},
    );
  }
}
