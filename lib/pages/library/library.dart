import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/library/user_albums.dart';
import 'package:spotube/components/library/user_artists.dart';
import 'package:spotube/components/library/user_downloads.dart';
import 'package:spotube/components/library/user_playlists.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';
import 'package:spotube/extensions/context.dart';

class LibraryPage extends HookConsumerWidget {
  const LibraryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PageWindowTitleBar(
            centerTitle: true,
            leading: ThemedButtonsTabBar(
              tabs: [
                context.l10n.playlists,
                context.l10n.tracks,
                context.l10n.downloads,
                context.l10n.artists,
                context.l10n.albums,
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
