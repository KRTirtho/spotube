import 'package:flutter/material.dart' hide Image;
import 'package:spotube/components/Library/UserArtists.dart';
import 'package:spotube/components/Library/UserPlaylists.dart';

class UserLibrary extends StatelessWidget {
  const UserLibrary({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          body: const TabBarView(children: [
            UserPlaylists(),
            UserArtists(),
            Icon(Icons.ac_unit_outlined),
          ]),
        ),
      ),
    );
  }
}
