import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/provider/metadata_plugin/artist/related.dart';

class ArtistPageRelatedArtists extends ConsumerWidget {
  final String artistId;
  const ArtistPageRelatedArtists({
    super.key,
    required this.artistId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final relatedArtists =
        ref.watch(metadataPluginArtistRelatedArtistsProvider(artistId));

    return switch (relatedArtists) {
      AsyncData(value: final artists) => SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverGrid.builder(
            itemCount: artists.items.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 250,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final artist = artists.items.elementAt(index);
              return SizedBox(
                width: 180,
                child: ArtistCard(artist),
              );
            },
          ),
        ),
      AsyncError(:final error) => SliverToBoxAdapter(
          child: Center(
            child: Text(error.toString()),
          ),
        ),
      _ => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
    };
  }
}
