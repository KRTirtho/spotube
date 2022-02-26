import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Playlist/PlaylistGenreView.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class CategoryCard extends HookWidget {
  final Category category;
  final Iterable<PlaylistSimple>? playlists;
  const CategoryCard(
    this.category, {
    Key? key,
    this.playlists,
  }) : super(key: key);

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
                category.name ?? "Unknown",
                style: Theme.of(context).textTheme.headline5,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    SpotubePageRoute(
                      child: PlaylistGenreView(
                        category.id!,
                        category.name!,
                        playlists: playlists,
                      ),
                    ),
                  );
                },
                child: const Text("See all"),
              )
            ],
          ),
        ),
        HookConsumer(
          builder: (context, ref, child) {
            SpotifyApi spotifyApi = ref.watch(spotifyProvider);
            final scrollController = useScrollController();
            return FutureBuilder<Iterable<PlaylistSimple>>(
                future: playlists == null
                    ? (category.id != "user-featured-playlists"
                            ? spotifyApi.playlists.getByCategoryId(category.id!)
                            : spotifyApi.playlists.featured)
                        .getPage(4, 0)
                        .then((value) => value.items ?? [])
                    : Future.value(playlists),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error occurred"));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return Scrollbar(
                    controller: scrollController,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: snapshot.data!
                            .map((playlist) => PlaylistCard(playlist))
                            .toList(),
                      ),
                    ),
                  );
                });
          },
        )
      ],
    );
  }
}
