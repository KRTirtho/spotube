import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/stats/common/artist_item.dart';

import 'package:spotube/provider/history/top.dart';

class StatsArtistsPage extends HookConsumerWidget {
  static const name = "stats_artists";
  const StatsArtistsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final artists = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.allTime)
          .select((s) => s.whenData((s) => s.artists)),
    );

    final artistsData = artists.asData?.value ?? [];

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Artists"),
      ),
      body: ListView.builder(
        itemCount: artistsData.length,
        itemBuilder: (context, index) {
          final artist = artistsData[index];
          return StatsArtistItem(
            artist: artist.artist,
            info: Text("${compactNumberFormatter.format(artist.count)} plays"),
          );
        },
      ),
    );
  }
}
