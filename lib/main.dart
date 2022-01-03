import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Home.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
        ChangeNotifierProvider<SpotifyDI>(create: (context) {
          Auth authState = Provider.of<Auth>(context, listen: false);
          return SpotifyDI(SpotifyApi(SpotifyApiCredentials(
              authState.cliendId, authState.clientSecret)));
        }),
        ChangeNotifierProvider<Playback>(create: (context) => Playback()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
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
            )),
        home: const Home(),
      ),
    );
  }
}
