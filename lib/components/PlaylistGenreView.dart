import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlaylistCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistGenreView extends StatefulWidget {
  String genre_id;
  PlaylistGenreView(this.genre_id);
  @override
  _PlaylistGenreViewState createState() => _PlaylistGenreViewState();
}

class _PlaylistGenreViewState extends State<PlaylistGenreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BackButton(),
                // genre name
                Expanded(
                  child: Text(
                    "Genre Name",
                    style: Theme.of(context).textTheme.headline4,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Consumer<SpotifyDI>(
              builder: (context, data, child) => Expanded(
                child: SingleChildScrollView(
                  child: FutureBuilder<Iterable<PlaylistSimple>>(
                      future: data.spotifyApi.playlists
                          .getByCategoryId(widget.genre_id)
                          .all(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text("Error occurred"));
                        }
                        if (!snapshot.hasData) {
                          return Center(child: Text("Loading.."));
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
      ),
    );
  }
}
