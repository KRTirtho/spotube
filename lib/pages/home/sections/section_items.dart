import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/components/playbutton_view/playbutton_card.dart';
import 'package:spotube/components/waypoint.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/provider/metadata_plugin/browse/section_items.dart';
import 'package:spotube/provider/metadata_plugin/utils/common.dart';

const _dummyPlaybuttonCard = PlaybuttonCard(
  imageUrl: 'https://placehold.co/150x150.png',
  isLoading: false,
  isPlaying: false,
  title: "Playbutton",
  description: "A really cool playbutton",
  isOwner: false,
);

@RoutePage()
class HomeBrowseSectionItemsPage extends HookConsumerWidget {
  static const name = "home_browse_section_items";

  final String sectionId;
  final SpotubeBrowseSectionObject<Object> section;
  const HomeBrowseSectionItemsPage({
    super.key,
    @PathParam("sectionId") required this.sectionId,
    required this.section,
  });

  @override
  Widget build(BuildContext context, ref) {
    final scale = context.theme.scaling;

    final sectionItems =
        ref.watch(metadataPluginBrowseSectionItemsProvider(sectionId));
    final sectionItemsNotifier =
        ref.watch(metadataPluginBrowseSectionItemsProvider(sectionId).notifier);
    final items = sectionItems.asData?.value.items ?? [];
    final controller = useScrollController();

    final isLoading = sectionItems.isLoading || sectionItems.isLoadingNextPage;
    final itemCount = items.length;
    final hasMore = sectionItems.asData?.value.hasMore ?? false;

    return SafeArea(
      bottom: false,
      child: Skeletonizer(
        enabled: sectionItems.isLoading,
        child: Scaffold(
          headers: [
            TitleBar(
              title: Text(section.title),
            )
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                SliverGrid.builder(
                  itemCount: isLoading ? 6 : itemCount + 1,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150 * scale,
                    mainAxisExtent: 225 * scale,
                    crossAxisSpacing: 12 * scale,
                    mainAxisSpacing: 12 * scale,
                  ),
                  itemBuilder: (context, index) {
                    if (isLoading) {
                      return const Skeletonizer(
                        enabled: true,
                        child: _dummyPlaybuttonCard,
                      );
                    }

                    if (index == itemCount) {
                      if (!hasMore) return const SizedBox.shrink();
                      return Waypoint(
                        controller: controller,
                        isGrid: true,
                        onTouchEdge: () async {
                          await sectionItemsNotifier.fetchMore();
                        },
                        child: const Skeletonizer(
                          enabled: true,
                          child: _dummyPlaybuttonCard,
                        ),
                      );
                    }

                    final item = items[index];
                    return switch (item) {
                      SpotubeFullArtistObject() => ArtistCard(item),
                      SpotubeSimplePlaylistObject() => PlaylistCard(item),
                      SpotubeSimpleAlbumObject() => AlbumCard(item),
                      _ => throw Exception(
                          "Unsupported item type: ${item.runtimeType}",
                        ),
                    };
                  },
                ),
                const SliverToBoxAdapter(
                  child: SafeArea(
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
