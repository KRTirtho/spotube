import 'package:flutter/material.dart' hide Page;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PagingController<int, Category> _pagingController =
      PagingController(firstPageKey: 0);

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
        _pagingController.addPageRequestListener((pageKey) async {
          try {
            SpotifyDI data = context.read<SpotifyDI>();
            Page<Category> categories = await data.spotifyApi.categories
                .list(country: "US")
                .getPage(15, pageKey);

            if (categories.isLast && categories.items != null) {
              _pagingController.appendLastPage(categories.items!.toList());
            } else if (categories.items != null) {
              _pagingController.appendPage(
                  categories.items!.toList(), categories.nextOffset);
            }
          } catch (e) {
            _pagingController.error = e;
          }
        });
      } catch (e) {
        print("[login state error]: $e");
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Auth authProvider = Provider.of<Auth>(context);
    if (!authProvider.isLoggedIn) {
      return Login();
    }

    return Scaffold(
      body: Column(
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
                                    style:
                                        Theme.of(context).textTheme.headline4),
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
                  return Expanded(
                    child: Scrollbar(
                      child: PagedListView(
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Category>(
                            itemBuilder: (context, item, index) {
                              return CategoryCard(item);
                            },
                          )),
                    ),
                  );
                }),
              ],
            ),
          ),
          // player itself
          const player.Player()
        ],
      ),
    );
  }
}
