import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/artist/artist_album_list.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/pages/artist/section/footer.dart';
import 'package:spotube/pages/artist/section/header.dart';
import 'package:spotube/pages/artist/section/related_artists.dart';
import 'package:spotube/pages/artist/section/top_tracks.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class ArtistPage extends HookConsumerWidget {
  static const name = "artist";

  final String artistId;
  const ArtistPage(this.artistId, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    final artistQuery = ref.watch(artistProvider(artistId));

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
          backgroundColor: Colors.transparent,
        ),
        extendBodyBehindAppBar: true,
        body: Builder(builder: (context) {
          if (artistQuery.hasError && artistQuery.asData?.value == null) {
            return Center(child: Text(artistQuery.error.toString()));
          }
          return Skeletonizer(
            enabled: artistQuery.isLoading,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: ArtistPageHeader(artistId: artistId),
                  ),
                ),
                const SliverGap(50),
                ArtistPageTopTracks(artistId: artistId),
                const SliverGap(50),
                SliverToBoxAdapter(child: ArtistAlbumList(artistId)),
                const SliverGap(20),
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      context.l10n.fans_also_like,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                SliverSafeArea(
                  sliver: ArtistPageRelatedArtists(artistId: artistId),
                ),
                if (artistQuery.asData?.value != null)
                  SliverSafeArea(
                    top: false,
                    sliver: SliverToBoxAdapter(
                      child:
                          ArtistPageFooter(artist: artistQuery.asData!.value),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
