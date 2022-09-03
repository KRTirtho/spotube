import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Expanded(
      child: DefaultTabController(
        length: 5,
        child: SafeArea(
          child: Scaffold(
            appBar: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Playlist"),
                Tab(text: "Downloads"),
                Tab(text: "Local"),
                Tab(text: "Artists"),
                Tab(text: "Album"),
              ],
            ),
            body: TabBarView(children: [
              const AnonymousFallback(child: UserPlaylists()),
              const UserDownloads(),
              const UserLocalTracks(),
              AnonymousFallback(child: UserArtists()),
              const AnonymousFallback(child: UserAlbums()),
            ]),
          ),
        ),
      ),
    );
  }
}
