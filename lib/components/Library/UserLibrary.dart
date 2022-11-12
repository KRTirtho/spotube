import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Library/UserAlbums.dart';
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserDownloads.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';

class UserLibrary extends HookConsumerWidget {
  const UserLibrary({Key? key}) : super(key: key);
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

    return PlatformScaffold(
      appBar: PageWindowTitleBar(
        titleWidth: 347,
        centerTitle: true,
        center: PlatformTabBar(
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
        ),
      ),
      body: body,
    );
  }
}
