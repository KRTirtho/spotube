import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/history/summary.dart';

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
        sliver: SliverLayoutBuilder(builder: (context, constraints) {
          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildListDelegate([
              _buildTile(
                context,
                title: summaryData.duration.inMinutes.toString(),
                unit: context.l10n.summary_minutes,
                icon: Icons.access_time,
                route: const StatsMinutesRoute(),
              ),
              _buildTile(
                context,
                title: summaryData.albums.toString(),
                unit: context.l10n.summary_full_albums,
                icon: Icons.album,
                route: const StatsAlbumsRoute(),
              ),
              _buildTile(
                context,
                title: summaryData.playlists.toString(),
                unit: context.l10n.summary_playlists,
                icon: Icons.playlist_play,
                route: const StatsPlaylistsRoute(),
              ),
              _buildTile(
                context,
                title: summaryData.artists.toString(),
                unit: context.l10n.artists,
                icon: Icons.person,
                route: const StatsArtistsRoute(),
              ),
              _buildTile(
                context,
                title: "\$ ${summaryData.fees.toString()}",
                unit: context.l10n.streaming_fees_hypothetical,
                icon: Icons.monetization_on,
                route: const StatsStreamFeesRoute(),
              ),
            ]),
          );
        }),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required String title,
    required String unit,
    required IconData icon,
    required PageRouteInfo route,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.navigateTo(route);
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 35,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              unit,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
