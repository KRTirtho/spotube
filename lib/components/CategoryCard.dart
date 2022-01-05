import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/PlaylistCard.dart';
import 'package:spotube/components/PlaylistGenreView.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final Iterable<PlaylistSimple>? playlists;
  const CategoryCard(
    this.category, {
    Key? key,
    this.playlists,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name ?? "Unknown",
                style: Theme.of(context).textTheme.headline5,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return PlaylistGenreView(
                          widget.category.id!,
                          widget.category.name!,
                          playlists: widget.playlists,
                        );
                      },
                    ),
                  );
                },
                child: const Text("See all"),
              )
            ],
          ),
        ),
        Consumer<SpotifyDI>(
          builder: (context, data, child) {
            return FutureBuilder<Iterable<PlaylistSimple>>(
                future: widget.playlists == null
                    ? (widget.category.id != "user-featured-playlists"
                            ? data.spotifyApi.playlists
                                .getByCategoryId(widget.category.id!)
                            : data.spotifyApi.playlists.featured)
                        .getPage(4, 0)
                        .then((value) => value.items ?? [])
                    : Future.value(widget.playlists),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error occurred"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: snapshot.data!
                        .map((playlist) => PlaylistCard(playlist))
                        .toList(),
                  );
                });
          },
        )
      ],
    );
  }
}
