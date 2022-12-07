import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class CategoryCard extends HookConsumerWidget {
  final Category category;
  final Iterable<PlaylistSimple>? playlists;
  CategoryCard(
    this.category, {
    Key? key,
    this.playlists,
  }) : super(key: key);

  final logger = getLogger(CategoryCard);

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final spotify = ref.watch(spotifyProvider);
    final playlistQuery = useInfiniteQuery(
      job: categoryPlaylistsQueryJob(category.id!),
      externalData: spotify,
    );
    final hasNextPage = playlistQuery.pages.isEmpty
        ? false
        : (playlistQuery.pages.last?.items?.length ?? 0) == 5;

    final playlists = playlistQuery.pages
        .expand(
          (page) => page?.items ?? const Iterable.empty(),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              PlatformText.headline(category.name ?? "Unknown"),
            ],
          ),
        ),
        playlistQuery.hasError
            ? PlatformText(
                "Something Went Wrong\n${playlistQuery.errors.first}")
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
                        playlistQuery.fetchNextPage();
                      },
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          ...playlists
                              .map((playlist) => PlaylistCard(playlist)),
                          if (hasNextPage)
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
