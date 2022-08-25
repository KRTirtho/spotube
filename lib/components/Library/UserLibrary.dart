import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Library/UserAlbums.dart';
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserDownloads.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';

class UserLibrary extends ConsumerWidget {
  const UserLibrary({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    return Expanded(
      child: DefaultTabController(
        length: 4,
        child: SafeArea(
          child: Scaffold(
            appBar: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Playlist"),
                Tab(text: "Artists"),
                Tab(text: "Album"),
                Tab(text: "Downloads"),
              ],
            ),
            body: TabBarView(children: [
              const AnonymousFallback(child: UserPlaylists()),
              AnonymousFallback(child: UserArtists()),
              const AnonymousFallback(child: UserAlbums()),
              const UserDownloads(),
            ]),
          ),
        ),
      ),
    );
  }
}
