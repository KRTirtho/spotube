import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';
import 'package:spotube/components/stats/top/albums.dart';
import 'package:spotube/components/stats/top/artists.dart';
import 'package:spotube/components/stats/top/tracks.dart';

class StatsPageTopSection extends HookConsumerWidget {
  const StatsPageTopSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final tabController = useTabController(initialLength: 3);

    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          floating: true,
          flexibleSpace: ThemedButtonsTabBar(
            controller: tabController,
            tabs: const [
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Tracks"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Artists"),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text("Top Albums"),
                ),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: tabController,
          builder: (context, _) {
            return switch (tabController.index) {
              1 => const TopArtists(),
              2 => const TopAlbums(),
              _ => const TopTracks(),
            };
          },
        ),
      ],
    );
  }
}
