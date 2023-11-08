import 'dart:ui';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/extensions/constrains.dart';
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

    final playlists = useMemoized(
      () => playlistQuery.pages.expand(
        (page) {
          return page.items?.where((i) => i != null) ?? const Iterable.empty();
        },
      ).toList(),
      [playlistQuery.pages],
    );

    if (playlistQuery.hasErrors &&
        !playlistQuery.hasPageData &&
        !playlistQuery.isLoadingNextPage) {
      return const SizedBox.shrink();
    }

    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: mediaQuery.smAndDown ? 226 : 266,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: playlists.length + 1,
                  itemBuilder: (context, index) {
                    if (index == playlists.length) {
                      if (!playlistQuery.hasNextPage) {
                        return const SizedBox.shrink();
                      }
                      return Waypoint(
                        controller: scrollController,
                        onTouchEdge: playlistQuery.fetchNext,
                        isGrid: true,
                        child: const ShimmerPlaybuttonCard(),
                      );
                    }
                    final playlist = playlists[index];
                    return PlaylistCard(playlist);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
