import 'package:flutter/material.dart' hide Page;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class ArtistAlbumView extends ConsumerStatefulWidget {
  final String artistId;
  final String artistName;
  const ArtistAlbumView(
    this.artistId,
    this.artistName, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ArtistAlbumView> createState() => _ArtistAlbumViewState();
}

class _ArtistAlbumViewState extends ConsumerState<ArtistAlbumView> {
  final PagingController<int, Album> _pagingController =
      PagingController<int, Album>(firstPageKey: 0);

  final logger = createLogger(ArtistAlbumView);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  _fetchPage(int pageKey) async {
    try {
      SpotifyApi spotifyApi = ref.watch(spotifyProvider);
      Page<Album> albums =
          await spotifyApi.artists.albums(widget.artistId).getPage(8, pageKey);

      var items = albums.items!.toList();

      if (albums.isLast && albums.items != null) {
        _pagingController.appendLastPage(items);
      } else if (albums.items != null) {
        _pagingController.appendPage(items, albums.nextOffset);
      }
    } catch (e, stack) {
      logger.e(e, null, stack);
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const PageWindowTitleBar(leading: BackButton()),
        body: Column(
          children: [
            Text(
              widget.artistName,
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: PagedGridView(
                pagingController: _pagingController,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  childAspectRatio: 9 / 13,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(10),
                builderDelegate: PagedChildBuilderDelegate<Album>(
                  itemBuilder: (context, item, index) {
                    return AlbumCard(item);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
