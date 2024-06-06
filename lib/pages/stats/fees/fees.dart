import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';
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
    final ThemeData(:textTheme, :hintColor) = Theme.of(context);

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
      body: CustomScrollView(
        slivers: [
          SliverCrossAxisConstrained(
            maxCrossAxisExtent: 600,
            alignment: -1,
            child: SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "*This is calculated based on Spotify's per stream "
                  "payout of \$0.003 to \$0.005. This is a hypothetical "
                  "calculation to give user insight about how much they "
                  "would have paid to the artists if they were to listen "
                  "their song in Spotify.",
                  style: textTheme.bodySmall?.copyWith(
                    color: hintColor,
                  ),
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return StatsArtistItem(
                artist: artist.artist,
                info: Text(usdFormatter.format(artist.count * 0.005)),
              );
            },
          ),
        ],
      ),
    );
  }
}
