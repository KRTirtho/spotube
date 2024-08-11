import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/modules/artist/artist_card.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class ArtistPageRelatedArtists extends ConsumerWidget {
  final String artistId;
  const ArtistPageRelatedArtists({
    super.key,
    required this.artistId,
  });

  @override
  Widget build(BuildContext context, ref) {
    final relatedArtists = ref.watch(relatedArtistsProvider(artistId));

    return switch (relatedArtists) {
      AsyncData(value: final artists) => SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverGrid.builder(
            itemCount: artists.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 250,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final artist = artists.elementAt(index);
              return ArtistCard(artist);
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
