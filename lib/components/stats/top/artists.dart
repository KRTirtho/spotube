import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/stats/common/artist_item.dart';
import 'package:spotube/provider/history/top.dart';

class TopArtists extends HookConsumerWidget {
  const TopArtists({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final artists = ref.watch(playbackHistoryTopProvider(historyDuration)
        .select((value) => value.artists));

    return SliverList.builder(
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return StatsArtistItem(
          artist: artist.artist,
          info: Text("${compactNumberFormatter.format(artist.count)} plays"),
        );
      },
    );
  }
}
