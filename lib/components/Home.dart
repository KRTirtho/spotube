import 'package:flutter/material.dart' hide Page;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/CategoryCard.dart';
import 'package:spotube/components/Login.dart';
import 'package:spotube/components/Player.dart' as player;
import 'package:spotube/models/sideBarTiles.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      try {
        Auth authProvider = context.read<Auth>();
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        String? clientId = localStorage.getString('client_id');
        String? clientSecret = localStorage.getString('client_secret');

        if (clientId != null && clientSecret != null) {
          SpotifyApi spotifyApi = SpotifyApi(
            SpotifyApiCredentials(clientId, clientSecret,
                scopes: ["user-library-read", "user-library-modify"]),
          );
          SpotifyApiCredentials credentials = await spotifyApi.getCredentials();
          if (credentials.accessToken?.isNotEmpty ?? false) {
            authProvider.setAuthState(
              clientId: credentials.clientId,
              clientSecret: credentials.clientSecret,
              isLoggedIn: true,
            );
          }
        }
      } catch (e) {
        print("[login state error]: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth authProvider = Provider.of<Auth>(context);
    if (!authProvider.isLoggedIn) {
      return Login();
    }

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            // Side Tab Bar
            Expanded(
              child: Row(
                children: [
                  Container(
                    color: Colors.grey.shade100,
                    constraints: const BoxConstraints(maxWidth: 230),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 1,
                            // TabButtons
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Spotube",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
                                  leading:
                                      const Icon(Icons.miscellaneous_services),
                                ),
                                const SizedBox(height: 20),
                                ...sidebarTileList
                                    .map(
                                      (sidebarTile) => ListTile(
                                        title: Text(sidebarTile.title),
                                        leading: Icon(sidebarTile.icon),
                                        onTap: () {},
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                          // user name & settings
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "User's name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                    icon: const Icon(Icons.settings_outlined),
                                    onPressed: () {}),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // contents of the spotify
                  Consumer<SpotifyDI>(builder: (_, data, __) {
                    return FutureBuilder<Page<Category>>(
                        future: data.spotifyApi.categories
                            .list(country: "US")
                            .getPage(10, 0),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text("Error occured"));
                          }
                          if (!snapshot.hasData) {
                            return const Center(child: Text("Loading"));
                          }
                          List<Category> categories =
                              snapshot.data!.items!.toList();
                          return Expanded(
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return CategoryCard(categories[index]);
                                },
                              ),
                            ),
                          );
                        });
                  }),
                ],
              ),
            ),
            // player itself
            const player.Player()
          ],
        ),
      ),
    );
  }
}
