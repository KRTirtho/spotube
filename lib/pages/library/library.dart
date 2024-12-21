import 'package:flutter/material.dart' show Badge;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/modules/library/user_albums.dart';
import 'package:spotube/modules/library/user_artists.dart';
import 'package:spotube/modules/library/user_downloads.dart';
import 'package:spotube/modules/library/user_playlists.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/download_manager_provider.dart';

class LibraryPage extends HookConsumerWidget {
  static const name = "library";

  const LibraryPage({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final downloadingCount = ref.watch(downloadManagerProvider).$downloadCount;
    final index = useState(0);

    final children = [
      Text(context.l10n.playlists),
      Text(context.l10n.local_tab),
      Badge(
        isLabelVisible: downloadingCount > 0,
        label: Text(downloadingCount.toString()),
        child: Text(context.l10n.downloads),
      ),
      Text(context.l10n.artists),
      Text(context.l10n.albums),
    ];

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          PageWindowTitleBar(
            leading: TabList(
              index: index.value,
              children: [
                for (final child in children)
                  TabButton(
                    child: child,
                    onPressed: () {
                      index.value = children.indexOf(child);
                    },
                  ),
              ],
            ),
          )
        ],
        child: IndexedStack(
          index: index.value,
          children: const [
            UserPlaylists(),
            UserLocalTracks(),
            UserDownloads(),
            UserArtists(),
            UserAlbums(),
            // Text("UserPlaylists()"),
            // Text("UserLocalTracks()"),
            // Text("UserDownloads()"),
            // Text("UserArtists()"),
            // Text("UserAlbums()"),
          ],
        ),
      ),
    );
  }
}
