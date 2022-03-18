import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Playlist/PlaylistCard.dart';
import 'package:spotube/hooks/usePagingController.dart';
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
            children: [
              Text(
                category.name ?? "Unknown",
                style: Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
        HookConsumer(
          builder: (context, ref, child) {
            SpotifyApi spotifyApi = ref.watch(spotifyProvider);
            final scrollController = useScrollController();
            final pagingController =
                usePagingController<int, PlaylistSimple>(firstPageKey: 0);

            final _error = useState(false);
            final mounted = useIsMounted();

            useEffect(() {
              listener(pageKey) async {
                try {
                  if (playlists != null &&
                      playlists?.isNotEmpty == true &&
                      mounted()) {
                    return pagingController.appendLastPage(playlists!.toList());
                  }
                  final Page<PlaylistSimple> page = await (category.id !=
                              "user-featured-playlists"
                          ? spotifyApi.playlists.getByCategoryId(category.id!)
                          : spotifyApi.playlists.featured)
                      .getPage(3, pageKey);

                  if (!mounted()) return;
                  if (page.isLast && page.items != null) {
                    pagingController.appendLastPage(page.items!.toList());
                  } else if (page.items != null) {
                    pagingController.appendPage(
                        page.items!.toList(), page.nextOffset);
                  }
                  if (_error.value) _error.value = false;
                } catch (e, stack) {
                  if (mounted()) {
                    if (!_error.value) _error.value = true;
                    pagingController.error = e;
                  }
                  print(
                      "[CategoryCard.pagingController.addPageRequestListener] $e");
                  print(stack);
                }
              }

              pagingController.addPageRequestListener(listener);
              return () {
                pagingController.removePageRequestListener(listener);
              };
            }, [_error]);

            if (_error.value) return const Text("Something Went Wrong");
            return SizedBox(
              height: 245,
              child: Scrollbar(
                controller: scrollController,
                child: PagedListView<int, PlaylistSimple>(
                  shrinkWrap: true,
                  pagingController: pagingController,
                  scrollController: scrollController,
                  scrollDirection: Axis.horizontal,
                  builderDelegate: PagedChildBuilderDelegate<PlaylistSimple>(
                    itemBuilder: (context, playlist, index) {
                      return PlaylistCard(playlist);
                    },
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
