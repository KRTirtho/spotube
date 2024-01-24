import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';

class SearchArtistsSection extends HookConsumerWidget {
  final InfiniteQuery<List<Page<dynamic>>, dynamic, int> query;

  const SearchArtistsSection({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final artists = useMemoized(
      () => query.pages
          .expand(
            (page) => page.map((p) => p.items!).expand((element) => element),
          )
          .whereType<Artist>()
          .toList(),
      [query.pages],
    );

    return HorizontalPlaybuttonCardView<Artist>(
      isLoadingNextPage: query.isLoadingNextPage,
      hasNextPage: query.hasNextPage,
      items: artists,
      onFetchMore: query.fetchNext,
      title: Text(context.l10n.artists),
    );
  }
}
