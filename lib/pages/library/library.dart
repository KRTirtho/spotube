import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/library/user_albums.dart';
import 'package:spotube/components/library/user_artists.dart';
import 'package:spotube/components/library/user_downloads.dart';
import 'package:spotube/components/library/user_playlists.dart';
import 'package:spotube/components/shared/themed_button_tab_bar.dart';

class LibraryPage extends HookConsumerWidget {
  const LibraryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    return const DefaultTabController(
      length: 5,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: PageWindowTitleBar(
            centerTitle: true,
            leading: ThemedButtonsTabBar(
              tabs: [
                'Playlists',
                'Tracks',
                'Downloads',
                'Artists',
                'Albums',
              ],
            ),
            leadingWidth: double.infinity,
          ),
          body: TabBarView(
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
