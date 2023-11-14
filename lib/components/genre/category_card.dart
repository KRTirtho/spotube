import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
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
    final playlistQuery = useQueries.category.playlistsOf(
      ref,
      category.id!,
    );

    final playlists = useMemoized(
      () => playlistQuery.pages.expand(
        (page) {
          return page.items?.whereNotNull() ??
              const Iterable<PlaylistSimple>.empty();
        },
      ).toList(),
      [playlistQuery.pages],
    );

    if (playlistQuery.hasErrors &&
        !playlistQuery.hasPageData &&
        !playlistQuery.isLoadingNextPage) {
      return const SizedBox.shrink();
    }

    return HorizontalPlaybuttonCardView<PlaylistSimple>(
      title: Text(category.name!),
      isLoadingNextPage: playlistQuery.isLoadingNextPage,
      hasNextPage: playlistQuery.hasNextPage,
      items: playlists,
      onFetchMore: playlistQuery.fetchNext,
    );
  }
}
