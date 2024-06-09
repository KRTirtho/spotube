import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/library/user_albums.dart';
import 'package:spotube/modules/library/user_artists.dart';
import 'package:spotube/modules/library/user_downloads.dart';
import 'package:spotube/modules/library/user_playlists.dart';
import 'package:spotube/components/themed_button_tab_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

class LibraryPage extends HookConsumerWidget {
  static const name = "library";

  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final downloadingCount = ref.watch(downloadManagerProvider).$downloadCount;

    return DefaultTabController(
      length: 5,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PageWindowTitleBar(
            centerTitle: true,
            leading: ThemedButtonsTabBar(
              tabs: [
                Tab(text: "  ${context.l10n.playlists}  "),
                Tab(text: "  ${context.l10n.local_tab}  "),
                Tab(
                  child: Badge(
                    isLabelVisible: downloadingCount > 0,
                    label: Text(downloadingCount.toString()),
                    child: Text("  ${context.l10n.downloads}  "),
                  ),
                ),
                Tab(text: "  ${context.l10n.artists}  "),
                Tab(text: "  ${context.l10n.albums}  "),
              ],
            ),
            leadingWidth: double.infinity,
          ),
          body: const TabBarView(
            children: [
              UserPlaylists(),
              UserLocalTracks(),
              UserDownloads(),
              UserArtists(),
              UserAlbums(),
            ],
          ),
        ),
      ),
    );
  }
}
