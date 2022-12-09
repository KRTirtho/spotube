import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/provider/spotify_provider.dart';

class PlaylistGenreView extends ConsumerWidget {
  final String genreId;
  final String genreName;
  final Iterable<PlaylistSimple>? playlists;
  const PlaylistGenreView(
    this.genreId,
    this.genreName, {
    this.playlists,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: const PlatformBackButton(),
      ),
      body: Column(
        children: [
          PlatformText.subheading(
            genreName,
            textAlign: TextAlign.center,
          ),
          Consumer(
            builder: (context, ref, child) {
              SpotifyApi spotifyApi = ref.watch(spotifyProvider);
              return Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<Iterable<PlaylistSimple>>(
                      future: playlists == null
                          ? (genreId != "user-featured-playlists"
                              ? spotifyApi.playlists
                                  .getByCategoryId(genreId)
                                  .all()
                              : spotifyApi.playlists.featured.all())
                          : Future.value(playlists),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text("Error occurred"));
                        }
                        if (!snapshot.hasData) {
                          return const PlatformCircularProgressIndicator();
                        }
                        return Center(
                          child: Wrap(
                            children: snapshot.data!
                                .map(
                                  (playlist) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PlaylistCard(playlist),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      }),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
