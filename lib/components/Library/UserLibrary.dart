import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Library/UserAlbums.dart';
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserDownloads.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';

class UserLibrary extends ConsumerWidget {
  const UserLibrary({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: PlatformTabView(
          placement: PlatformProperty.all(PlatformTabbarPlacement.top),
          body: {
            PlatformTab(
              label: "Playlist",
              icon: Container(),
            ): const AnonymousFallback(child: UserPlaylists()),
            PlatformTab(
              label: "Downloads",
              icon: Container(),
            ): const UserDownloads(),
            PlatformTab(
              label: "Local",
              icon: Container(),
            ): const UserLocalTracks(),
            PlatformTab(
              label: "Artists",
              icon: Container(),
            ): const AnonymousFallback(child: UserArtists()),
            PlatformTab(
              label: "Album",
              icon: Container(),
            ): const AnonymousFallback(child: UserAlbums()),
          },
        ),
      ),
    );
  }
}
