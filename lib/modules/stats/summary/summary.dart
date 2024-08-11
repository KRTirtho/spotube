import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/modules/stats/summary/summary_card.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
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
    final summaryData = summary.asData?.value ?? FakeData.historySummary;

    return Skeletonizer.sliver(
      enabled: summary.isLoading,
      child: SliverPadding(
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
                title: summaryData.duration.inMinutes.toDouble(),
                unit: context.l10n.summary_minutes,
                description: context.l10n.summary_listened_to_music,
                color: Colors.purple,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsMinutesPage.name);
                },
              ),
              SummaryCard(
                title: summaryData.tracks.toDouble(),
                unit: context.l10n.summary_songs,
                description: context.l10n.summary_streamed_overall,
                color: Colors.lightBlue,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsStreamsPage.name);
                },
              ),
              SummaryCard.unformatted(
                title: usdFormatter.format(summaryData.fees.toDouble()),
                unit: "",
                description: context.l10n.summary_owed_to_artists,
                color: Colors.green,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsStreamFeesPage.name);
                },
              ),
              SummaryCard(
                title: summaryData.artists.toDouble(),
                unit: context.l10n.summary_artists,
                description: context.l10n.summary_music_reached_you,
                color: Colors.yellow,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsArtistsPage.name);
                },
              ),
              SummaryCard(
                title: summaryData.albums.toDouble(),
                unit: context.l10n.summary_full_albums,
                description: context.l10n.summary_got_your_love,
                color: Colors.pink,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsAlbumsPage.name);
                },
              ),
              SummaryCard(
                title: summaryData.playlists.toDouble(),
                unit: context.l10n.summary_playlists,
                description: context.l10n.summary_were_on_repeat,
                color: Colors.teal,
                onTap: () {
                  ServiceUtils.pushNamed(context, StatsPlaylistsPage.name);
                },
              ),
            ]),
          );
        }),
      ),
    );
  }
}
