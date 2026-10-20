import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/modules/root/spotify_bottom_player.dart';
import 'package:spotube/modules/root/spotify_sidebar.dart';
import 'package:spotube/modules/root/spotify_top_bar.dart';

class SpotifyShell extends HookWidget {
  const SpotifyShell({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      backgroundColor: SpotifyColors.background,
      body: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SpotifySidebar(),
                Container(width: 1, color: SpotifyColors.separator),
                Expanded(
                  child: Column(
                    children: [
                      SpotifyTopBar(scrollController: scrollController),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 98),
                          child: AutoRouter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpotifyBottomPlayer(),
        ],
      ),
    );
  }
}
