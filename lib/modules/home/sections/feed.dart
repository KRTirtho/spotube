import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify/views/home.dart';

class HomePageFeedSection extends HookConsumerWidget {
  const HomePageFeedSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final homeFeed = ref.watch(homeViewProvider);
    final nonShortSections = homeFeed.asData?.value.sections
            .where((s) => s.typename == "HomeGenericSectionData")
            .toList() ??
        [];

    return SliverList.builder(
      itemCount: nonShortSections.length,
      itemBuilder: (context, index) {
        final section = nonShortSections[index];
        if (section.items.isEmpty) return const SizedBox.shrink();

        return HorizontalPlaybuttonCardView(
          items: [
            for (final item in section.items)
              if (item.album != null)
                item.album!.asAlbum
              else if (item.artist != null)
                item.artist!.asArtist
              else if (item.playlist != null)
                item.playlist!.asPlaylist
          ],
          title: Text(section.title ?? context.l10n.no_title),
          hasNextPage: false,
          isLoadingNextPage: false,
          onFetchMore: () {},
          titleTrailing: Button.text(
            child: Text(context.l10n.browse_all),
            onPressed: () {
              context.navigateTo(HomeFeedSectionRoute(sectionUri: section.uri));
            },
          ),
        );
      },
    );
  }
}
