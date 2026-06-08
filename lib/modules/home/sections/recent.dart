import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/history/recent.dart';

class HomeRecentlyPlayedSection extends HookConsumerWidget {
  const HomeRecentlyPlayedSection({super.key});
    
  @override
  Widget build(BuildContext context, ref) {
    final history = ref.watch(recentlyPlayedItems);
    final historyData =
        history.asData?.value ?? FakeData.historyRecentlyPlayedItems;

    if (history.asData?.value.isEmpty == true) {
      return const SizedBox();
    }

    final uniqueItems = <dynamic>{};
    final filteredItems = [
      for (final item in historyData)
        if (item.playlist != null && item.playlist?.id != null && uniqueItems.add(item.playlist!.id!))
          item.playlist
        else if (item.album != null && item.album?.id != null && uniqueItems.add(item.album?.id))
          item.album
    ];

    return Skeletonizer(
      enabled: history.isLoading,
      child: HorizontalPlaybuttonCardView(
        title: Text(context.l10n.recently_played),
        items: filteredItems,
        hasNextPage: false,
        isLoadingNextPage: false,
        onFetchMore: () {},
      ),
    );
  }
}
