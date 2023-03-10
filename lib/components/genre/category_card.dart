import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/services/queries/queries.dart';

class CategoryCard extends HookConsumerWidget {
  final Category category;
  CategoryCard(
    this.category, {
    Key? key,
  }) : super(key: key);

  final logger = getLogger(CategoryCard);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final playlistQuery = useQueries.category.playlistsOf(
      ref,
      category.id!,
    );

    final playlists = playlistQuery.pages
        .expand(
          (page) => page.items ?? const Iterable.empty(),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                category.name ?? "Unknown",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        playlistQuery.hasPageError && !playlistQuery.hasPageData
            ? Text("Something Went Wrong\n${playlistQuery.errors.first}")
            : SizedBox(
                height: 245,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: Scrollbar(
                    controller: scrollController,
                    interactive: false,
                    child: Waypoint(
                      controller: scrollController,
                      onTouchEdge: () {
                        playlistQuery.fetchNext();
                      },
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          ...playlists
                              .map((playlist) => PlaylistCard(playlist)),
                          if (playlistQuery.hasNextPage)
                            const ShimmerPlaybuttonCard(count: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
