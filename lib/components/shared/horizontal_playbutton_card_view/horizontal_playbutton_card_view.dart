import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/waypoint.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';

class HorizontalPlaybuttonCardView<T> extends HookWidget {
  final Widget title;
  final List<T> items;
  final VoidCallback onFetchMore;
  final bool hasNextPage;
  const HorizontalPlaybuttonCardView({
    required this.title,
    required this.items,
    required this.hasNextPage,
    required this.onFetchMore,
    Key? key,
  })  : assert(
          items is List<PlaylistSimple> ||
              items is List<Album> ||
              items is List<Artist>,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData(:textTheme) = Theme.of(context);
    final scrollController = useScrollController();
    final height = useBreakpointValue<double>(
      xs: 226,
      sm: 226,
      md: 236,
      others: 266,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: textTheme.titleMedium!,
            child: title,
          ),
          SizedBox(
            height: height,
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
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      if (!hasNextPage) {
                        return const SizedBox.shrink();
                      }
                      return Waypoint(
                        controller: scrollController,
                        onTouchEdge: onFetchMore,
                        isGrid: true,
                        child: const ShimmerPlaybuttonCard(),
                      );
                    }
                    final item = items[index];

                    return switch (item.runtimeType) {
                      PlaylistSimple => PlaylistCard(item as PlaylistSimple),
                      Album => AlbumCard(item as Album),
                      Artist => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ArtistCard(item as Artist),
                        ),
                      _ => const SizedBox.shrink(),
                    };
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
