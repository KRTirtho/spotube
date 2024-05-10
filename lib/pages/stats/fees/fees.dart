import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/stats/common/artist_item.dart';
import 'package:spotube/provider/history/state.dart';
import 'package:spotube/provider/history/top.dart';

class StatsStreamFeesPage extends HookConsumerWidget {
  static const name = "stats_stream_fees";

  const StatsStreamFeesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final artists = ref.watch(
      playbackHistoryTopProvider(HistoryDuration.days30)
          .select((value) => value.artists),
    );

    return Scaffold(
      appBar: const PageWindowTitleBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text("Streaming fees (hypothetical)"),
      ),
      body: ListView.builder(
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return StatsArtistItem(
            artist: artist.artist,
            info: Text(usdFormatter.format(artist.count * 0.005)),
          );
        },
      ),
    );
  }
}
