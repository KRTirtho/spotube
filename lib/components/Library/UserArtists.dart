import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/hooks/usePaginatedFutureProvider.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class UserArtists extends HookConsumerWidget {
  UserArtists({Key? key}) : super(key: key);
  final logger = getLogger(UserArtists);

  @override
  Widget build(BuildContext context, ref) {
    final pagingController =
        usePaginatedFutureProvider<CursorPage<Artist>, String, Artist>(
      (pageKey) => currentUserFollowingArtistsQuery(pageKey),
      ref: ref,
      firstPageKey: "",
      onData: (artists, pagingController, pageKey) {
        final items = artists.items!.toList();

        if (artists.items != null && items.length < 15) {
          pagingController.appendLastPage(items);
        } else if (artists.items != null) {
          pagingController.appendPage(items, items.last.id);
        }
      },
    );

    return PagedGridView(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 9 / 11,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      padding: const EdgeInsets.all(10),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Artist>(
        itemBuilder: (context, item, index) {
          return ArtistCard(item);
        },
      ),
    );
  }
}
