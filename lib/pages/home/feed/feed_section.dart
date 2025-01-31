import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/playbutton_view/playbutton_view.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/provider/spotify/views/home_section.dart';

@RoutePage()
class HomeFeedSectionPage extends HookConsumerWidget {
  static const name = "home_feed_section";

  final String sectionUri;
  const HomeFeedSectionPage({
    super.key,
    @PathParam("feedId") required this.sectionUri,
  });

  @override
  Widget build(BuildContext context, ref) {
    final homeFeedSection = ref.watch(homeSectionViewProvider(sectionUri));
    final section = homeFeedSection.asData?.value ?? FakeData.feedSection;
    final controller = useScrollController();
    final isArtist = section.items.every((item) => item.artist != null);

    return SafeArea(
      bottom: false,
      child: Skeletonizer(
        enabled: homeFeedSection.isLoading,
        child: Scaffold(
          headers: [
            TitleBar(
              title: Text(section.title ?? ""),
            )
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomScrollView(
              controller: controller,
              slivers: [
                if (isArtist)
                  SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      mainAxisExtent: 250,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: section.items.length,
                    itemBuilder: (context, index) {
                      final item = section.items[index];
                      return ArtistCard(item.artist!.asArtist);
                    },
                  )
                else
                  PlaybuttonView(
                    controller: controller,
                    itemCount: section.items.length,
                    hasMore: false,
                    isLoading: false,
                    onRequestMore: () => {},
                    listItemBuilder: (context, index) {
                      final item = section.items[index];
                      if (item.album != null) {
                        return AlbumCard.tile(item.album!.asAlbum);
                      }
                      if (item.playlist != null) {
                        return PlaylistCard.tile(item.playlist!.asPlaylist);
                      }
                      return const SizedBox.shrink();
                    },
                    gridItemBuilder: (context, index) {
                      final item = section.items[index];
                      if (item.album != null) {
                        return AlbumCard(item.album!.asAlbum);
                      }
                      if (item.playlist != null) {
                        return PlaylistCard(item.playlist!.asPlaylist);
                      }
                      return const SizedBox.shrink();
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
