import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/helpers/simple-album-to-album.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class UserAlbums extends ConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    SpotifyApi spotifyApi = ref.watch(spotifyProvider);

    return FutureBuilder<Iterable<AlbumSimple>>(
      future: spotifyApi.me.savedAlbums().all(),
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.data == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 20, // gap between adjacent chips
              runSpacing: 20, // gap between lines
              alignment: WrapAlignment.center,
              children: snapshot.data!
                  .map((album) => AlbumCard(simpleAlbumToAlbum(album)))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
