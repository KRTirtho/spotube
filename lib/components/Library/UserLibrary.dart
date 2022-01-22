import 'package:flutter/material.dart' hide Image;
import 'package:spotube/components/Library/UserPlaylists.dart';

class UserLibrary extends StatefulWidget {
  const UserLibrary({Key? key}) : super(key: key);

  @override
  _UserLibraryState createState() => _UserLibraryState();
}

class _UserLibraryState extends State<UserLibrary> {
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
            Icon(Icons.ac_unit_outlined),
            Icon(Icons.ac_unit_outlined),
          ]),
        ),
      ),
    );
  }
}
