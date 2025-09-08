import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/provider/metadata_plugin/search/all.dart';

class SearchArtistsSection extends HookConsumerWidget {
  const SearchArtistsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final searchTerm = ref.watch(searchTermStateProvider);
    final search = ref.watch(metadataPluginSearchAllProvider(searchTerm));

    final artists = search.asData?.value.artists ?? [];

    return HorizontalPlaybuttonCardView(
      isLoadingNextPage: false,
      hasNextPage: false,
      items: artists,
      onFetchMore: () {},
      title: Text(context.l10n.artists),
    );
  }
}
