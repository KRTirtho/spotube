import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/services/queries/queries.dart';

class ArtistAlbumList extends HookConsumerWidget {
  final String artistId;
  ArtistAlbumList(
    this.artistId, {
    Key? key,
  }) : super(key: key);

  final logger = getLogger(ArtistAlbumList);

  @override
  Widget build(BuildContext context, ref) {
    final albumsQuery = useQueries.artist.albumsOf(ref, artistId);

    final albums = useMemoized(() {
      return albumsQuery.pages
          .expand<Album>((page) => page.items ?? const Iterable.empty())
          .toList();
    }, [albumsQuery.pages]);

    final theme = Theme.of(context);

    return HorizontalPlaybuttonCardView<Album>(
      isLoadingNextPage: albumsQuery.isLoadingNextPage,
      hasNextPage: albumsQuery.hasNextPage,
      items: albums,
      onFetchMore: albumsQuery.fetchNext,
      title: Text(
        context.l10n.albums,
        style: theme.textTheme.headlineSmall,
      ),
    );
  }
}
