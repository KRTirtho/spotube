import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class SearchArtistsSection extends HookConsumerWidget {
  const SearchArtistsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final query = ref.watch(searchProvider(SearchType.artist));
    final notifier = ref.watch(searchProvider(SearchType.artist).notifier);

    final artists = query.asData?.value.items.cast<Artist>() ?? [];

    return HorizontalPlaybuttonCardView<Artist>(
      isLoadingNextPage: query.isLoadingNextPage,
      hasNextPage: query.asData?.value.hasMore == true,
      items: artists,
      onFetchMore: notifier.fetchMore,
      title: Text(context.l10n.artists),
    );
  }
}
