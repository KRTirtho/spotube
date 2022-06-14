import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/components/Shared/NotFound.dart';
import 'package:spotube/hooks/usePaginatedFutureProvider.dart';
import 'package:spotube/models/Logger.dart';
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
    final mounted = useIsMounted();

    final pagingController =
        usePaginatedFutureProvider<Page<PlaylistSimple>, int, PlaylistSimple>(
      (pageKey) => categoryPlaylistsQuery(
        [
          category.id,
          pageKey,
        ].join("/"),
      ),
      ref: ref,
      firstPageKey: 0,
      onData: (page, pagingController, pageKey) {
        if (playlists != null && playlists?.isNotEmpty == true && mounted()) {
          return pagingController.appendLastPage(playlists!.toList());
        }
        if (page.isLast && page.items != null) {
          pagingController.appendLastPage(page.items!.toList());
        } else if (page.items != null) {
          pagingController.appendPage(page.items!.toList(), page.nextOffset);
        }
      },
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                category.name ?? "Unknown",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        pagingController.error != null
            ? const Text("Something Went Wrong")
            : SizedBox(
                height: 245,
                child: Scrollbar(
                  controller: scrollController,
                  child: PagedListView<int, PlaylistSimple>(
                    shrinkWrap: true,
                    pagingController: pagingController,
                    scrollController: scrollController,
                    scrollDirection: Axis.horizontal,
                    builderDelegate: PagedChildBuilderDelegate<PlaylistSimple>(
                      noItemsFoundIndicatorBuilder: (context) {
                        return const NotFound();
                      },
                      firstPageProgressIndicatorBuilder: (context) {
                        return const ShimmerPlaybuttonCard();
                      },
                      newPageProgressIndicatorBuilder: (context) {
                        return const ShimmerPlaybuttonCard();
                      },
                      itemBuilder: (context, playlist, index) {
                        return PlaylistCard(playlist);
                      },
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
