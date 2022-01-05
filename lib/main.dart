import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Home.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

void main() {
  runApp(MyApp());
  doWhenWindowReady(() {
    appWindow.minSize = const Size(900, 700);
    appWindow.alignment = Alignment.center;
    appWindow.maximize();
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<SpotifyDI>(create: (context) {
          Auth authState = Provider.of<Auth>(context, listen: false);
          return SpotifyDI(
            SpotifyApi(
              SpotifyApiCredentials(
                authState.clientId,
                authState.clientSecret,
                accessToken: authState.accessToken,
                refreshToken: authState.refreshToken,
                expiration: authState.expiration,
                scopes: spotifyScopes,
              ),
              onCredentialsRefreshed: (credentials) async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                localStorage.setString(
                  LocalStorageKeys.refreshToken,
                  credentials.refreshToken!,
                );
                localStorage.setString(
                  LocalStorageKeys.accessToken,
                  credentials.accessToken!,
                );
                localStorage.setString(
                    LocalStorageKeys.clientId, credentials.clientId!);
                localStorage.setString(
                  LocalStorageKeys.clientSecret,
                  credentials.clientSecret!,
                );
              },
            ),
          );
        }),
        ChangeNotifierProvider<Playback>(create: (context) => Playback()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spotube',
        theme: ThemeData(
          primaryColor: Colors.greenAccent[400],
          primarySwatch: Colors.green,
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.green,
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.grey[850]),
            headline1: TextStyle(color: Colors.grey[850]),
            headline2: TextStyle(color: Colors.grey[850]),
            headline3: TextStyle(color: Colors.grey[850]),
            headline4: TextStyle(color: Colors.grey[850]),
            headline5: TextStyle(color: Colors.grey[850]),
            headline6: TextStyle(color: Colors.grey[850]),
          ),
          listTileTheme: ListTileThemeData(
            iconColor: Colors.grey[850],
            horizontalTitleGap: 0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.green[400]!,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[800]!,
              ),
            ),
          ),
          navigationRailTheme: NavigationRailThemeData(
            backgroundColor: Colors.blueGrey[50],
            unselectedIconTheme:
                IconThemeData(color: Colors.grey[850], opacity: 1),
            unselectedLabelTextStyle: TextStyle(
              color: Colors.grey[850],
            ),
          ),
        ),
        home: const Home(),
      ),
    );
  }
}
