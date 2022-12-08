import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/library/user_albums.dart';
import 'package:spotube/components/library/user_artists.dart';
import 'package:spotube/components/library/user_downloads.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/components/library/user_playlists.dart';

class LibraryPage extends HookConsumerWidget {
  const LibraryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final index = useState(0);

    final body = [
      const UserPlaylists(),
      const UserLocalTracks(),
      const UserDownloads(),
      const UserArtists(),
      const UserAlbums(),
    ][index.value];

    var tabbar = PlatformTabBar(
      androidIsScrollable: true,
      selectedIndex: index.value,
      onSelectedIndexChanged: (value) => index.value = value,
      isNavigational:
          PlatformProperty.byPlatformGroup(mobile: false, desktop: true),
      tabs: [
        PlatformTab(label: 'Playlists', icon: const SizedBox.shrink()),
        PlatformTab(label: 'Tracks', icon: const SizedBox.shrink()),
        PlatformTab(label: 'Downloads', icon: const SizedBox.shrink()),
        PlatformTab(label: 'Artists', icon: const SizedBox.shrink()),
        PlatformTab(label: 'Albums', icon: const SizedBox.shrink()),
      ],
    );
    return SafeArea(
      child: PlatformScaffold(
        appBar: platform == TargetPlatform.windows
            ? PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: tabbar,
              )
            : PageWindowTitleBar(
                titleWidth: 347,
                centerTitle: true,
                center: tabbar,
              ),
        body: body,
      ),
    );
  }
}
