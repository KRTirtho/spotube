import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Library/UserAlbums.dart';
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';
import 'package:spotube/components/Shared/AnonymousFallback.dart';
import 'package:spotube/provider/Auth.dart';

class UserLibrary extends ConsumerWidget {
  const UserLibrary({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final Auth auth = ref.watch(authProvider);

    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            indicator: const BoxDecoration(color: Colors.transparent),
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).textTheme.bodyText1?.color,
            tabs: const [
              Tab(text: "Playlist"),
              Tab(text: "Artists"),
              Tab(text: "Album"),
            ],
          ),
          body: auth.isLoggedIn
              ? TabBarView(children: [
                  const UserPlaylists(),
                  UserArtists(),
                  const UserAlbums(),
                ])
              : const AnonymousFallback(),
        ),
      ),
    );
  }
}
