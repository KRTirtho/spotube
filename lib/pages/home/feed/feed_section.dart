import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/spotify/views/home_section.dart';

class HomeFeedSectionPage extends HookConsumerWidget {
  static const name = "home_feed_section";

  final String sectionUri;
  const HomeFeedSectionPage({super.key, required this.sectionUri});

  @override
  Widget build(BuildContext context, ref) {
    final homeFeedSection = ref.watch(homeSectionViewProvider(sectionUri));
    final section = homeFeedSection.asData?.value ?? FakeData.feedSection;

    return Skeletonizer(
      enabled: homeFeedSection.isLoading,
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(section.title ?? ""),
          centerTitle: false,
          automaticallyImplyLeading: true,
          titleSpacing: 0,
        ),
        body: CustomScrollView(
          slivers: [
            SliverLayoutBuilder(
              builder: (context, constrains) {
                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: constrains.smAndDown ? 225 : 250,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: section.items.length,
                  itemBuilder: (context, index) {
                    final item = section.items[index];

                    if (item.album != null) {
                      return AlbumCard(item.album!.asAlbum);
                    } else if (item.artist != null) {
                      return ArtistCard(item.artist!.asArtist);
                    } else if (item.playlist != null) {
                      return PlaylistCard(item.playlist!.asPlaylist);
                    }
                    return const SizedBox();
                  },
                );
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
    );
  }
}
