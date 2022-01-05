import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PageWindowTitleBar.dart';
import 'package:spotube/components/PlaylistCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistGenreView extends StatefulWidget {
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
  _PlaylistGenreViewState createState() => _PlaylistGenreViewState();
}

class _PlaylistGenreViewState extends State<PlaylistGenreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const PageWindowTitleBar(
            leading: BackButton(),
          ),
          Text(
            widget.genreName,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          Consumer<SpotifyDI>(
            builder: (context, data, child) => Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Iterable<PlaylistSimple>>(
                    future: widget.playlists == null
                        ? (widget.genreId != "user-featured-playlists"
                            ? data.spotifyApi.playlists
                                .getByCategoryId(widget.genreId)
                                .all()
                            : data.spotifyApi.playlists.featured.all())
                        : Future.value(widget.playlists),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text("Error occurred"));
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return Wrap(
                        children: snapshot.data!
                            .map(
                              (playlist) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PlaylistCard(playlist),
                              ),
                            )
                            .toList(),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
