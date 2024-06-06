import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/stats/summary/summary_card.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/pages/stats/albums/albums.dart';
import 'package:spotube/pages/stats/artists/artists.dart';
import 'package:spotube/pages/stats/fees/fees.dart';
import 'package:spotube/pages/stats/minutes/minutes.dart';
import 'package:spotube/pages/stats/playlists/playlists.dart';
import 'package:spotube/pages/stats/streams/streams.dart';
import 'package:spotube/provider/history/summary.dart';
import 'package:spotube/utils/service_utils.dart';

class StatsPageSummarySection extends HookConsumerWidget {
  const StatsPageSummarySection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final summary = ref.watch(playbackHistorySummaryProvider);

    return SliverPadding(
      padding: const EdgeInsets.all(10),
      sliver: SliverLayoutBuilder(builder: (context, constrains) {
        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constrains.isXs
                ? 2
                : constrains.smAndDown
                    ? 3
                    : constrains.mdAndDown
                        ? 4
                        : constrains.lgAndDown
                            ? 5
                            : 6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: constrains.isXs ? 1.3 : 1.5,
          ),
          delegate: SliverChildListDelegate([
            SummaryCard(
              title: summary.duration.inMinutes.toDouble(),
              unit: "minutes",
              description: 'Listened to music',
              color: Colors.purple,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsMinutesPage.name);
              },
            ),
            SummaryCard(
              title: summary.tracks.toDouble(),
              unit: "songs",
              description: 'Streamed overall',
              color: Colors.lightBlue,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsStreamsPage.name);
              },
            ),
            SummaryCard.unformatted(
              title: usdFormatter.format(summary.fees.toDouble()),
              unit: "",
              description: 'Owed to artists\nthis month',
              color: Colors.green,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsStreamFeesPage.name);
              },
            ),
            SummaryCard(
              title: summary.artists.toDouble(),
              unit: "artist's",
              description: 'Music reached you',
              color: Colors.yellow,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsArtistsPage.name);
              },
            ),
            SummaryCard(
              title: summary.albums.toDouble(),
              unit: "full albums",
              description: 'Got your love',
              color: Colors.pink,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsAlbumsPage.name);
              },
            ),
            SummaryCard(
              title: summary.playlists.toDouble(),
              unit: "playlists",
              description: 'Were on repeat',
              color: Colors.teal,
              onTap: () {
                ServiceUtils.pushNamed(context, StatsPlaylistsPage.name);
              },
            ),
          ]),
        );
      }),
    );
  }
}
