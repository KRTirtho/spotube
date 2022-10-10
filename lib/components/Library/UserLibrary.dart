import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Library/UserAlbums.dart';
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserDownloads.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';
import 'package:spotube/components/Shared/ColoredTabBar.dart';

class UserLibrary extends ConsumerWidget {
  const UserLibrary({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    return DefaultTabController(
      length: 5,
      child: SafeArea(
        child: Scaffold(
          appBar: ColoredTabBar(
            color: Theme.of(context).backgroundColor,
            child: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Playlist"),
                Tab(text: "Downloads"),
                Tab(text: "Local"),
                Tab(text: "Artists"),
                Tab(text: "Album"),
              ],
            ),
          ),
          body: const TabBarView(children: [
            AnonymousFallback(child: UserPlaylists()),
            UserDownloads(),
            UserLocalTracks(),
            AnonymousFallback(child: UserArtists()),
            AnonymousFallback(child: UserAlbums()),
          ]),
        ),
      ),
    );
  }
}
