import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/artist/artist_card.dart';
import 'package:spotube/services/queries/queries.dart';

class ArtistPageRelatedArtists extends HookConsumerWidget {
  final String artistId;
  const ArtistPageRelatedArtists({
    Key? key,
    required this.artistId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final relatedArtists = useQueries.artist.relatedArtistsOf(
      ref,
      artistId,
    );

    if (relatedArtists.isLoading || !relatedArtists.hasData) {
      return const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    } else if (relatedArtists.hasError) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(relatedArtists.error.toString()),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: SliverGrid.builder(
        itemCount: relatedArtists.data!.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 250,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final artist = relatedArtists.data!.elementAt(index);
          return ArtistCard(artist);
        },
      ),
    );
  }
}
