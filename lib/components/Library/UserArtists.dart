import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class UserArtists extends ConsumerStatefulWidget {
  const UserArtists({Key? key}) : super(key: key);

  @override
  ConsumerState<UserArtists> createState() => _UserArtistsState();
}

class _UserArtistsState extends ConsumerState<UserArtists> {
  final PagingController<String, Artist> _pagingController =
      PagingController(firstPageKey: "");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timestamp) {
      _pagingController.addPageRequestListener((pageKey) async {
        try {
          SpotifyApi spotifyApi = ref.read(spotifyProvider);
          CursorPage<Artist> artists = await spotifyApi.me
              .following(FollowingType.artist)
              .getPage(15, pageKey);

          var items = artists.items!.toList();

          if (artists.items != null && items.length < 15) {
            _pagingController.appendLastPage(items);
          } else if (artists.items != null) {
            _pagingController.appendPage(items, items.last.id);
          }
        } catch (e, stack) {
          _pagingController.error = e;
          print("[UserArtists.pagingController]: $e");
          print(stack);
        }
      });
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SpotifyApi spotifyApi = ref.watch(spotifyProvider);

    return FutureBuilder<CursorPage<Artist>>(
      future: spotifyApi.me.following(FollowingType.artist).first(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return PagedGridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 9 / 11,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          padding: const EdgeInsets.all(10),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Artist>(
            itemBuilder: (context, item, index) {
              return ArtistCard(item);
            },
          ),
        );
      },
    );
  }
}
