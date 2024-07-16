import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/horizontal_playbutton_card_view/horizontal_playbutton_card_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/home/feed/feed_section.dart';
import 'package:spotube/provider/spotify/views/home.dart';
import 'package:spotube/utils/service_utils.dart';

class HomePageFeedSection extends HookConsumerWidget {
  const HomePageFeedSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final homeFeed = ref.watch(homeViewProvider);
    final nonShortSections = homeFeed.asData?.value?.sections
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
          titleTrailing: Directionality(
            textDirection: TextDirection.rtl,
            child: TextButton.icon(
              label: Text(context.l10n.browse_more),
              icon: const Icon(SpotubeIcons.angleRight),
              onPressed: () => ServiceUtils.pushNamed(
                context,
                HomeFeedSectionPage.name,
                pathParameters: {
                  "feedId": section.uri,
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
