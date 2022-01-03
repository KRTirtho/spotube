import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/server_ipc.dart';
import 'package:spotube/provider/Auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String client_id = "";
  String client_secret = "";
  bool _fieldError = false;

  handleLogin(Auth authState) async {
    try {
      if (client_id == "" || client_secret == "") {
        return setState(() {
          _fieldError = true;
        });
      }
      final credentials = SpotifyApiCredentials(client_id, client_secret);
      final grant = SpotifyApi.authorizationCodeGrant(credentials);
      final redirectUri = "http://localhost:4304/auth/spotify/callback";
      final scopes = ["user-library-read", "user-library-modify"];

      final authUri =
          grant.getAuthorizationUrl(Uri.parse(redirectUri), scopes: scopes);

      final responseUri = await connectIpc(authUri.toString(), redirectUri);
      if (responseUri != null) {
        final SpotifyApi spotify =
            SpotifyApi.fromAuthCodeGrant(grant, responseUri);
      }

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setString('client_id', client_id);
      await localStorage.setString('client_secret', client_secret);
      authState.setAuthState(
          clientId: client_id, clientSecret: client_secret, isLoggedIn: true);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authState, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Add your spotify credentials to get started",
                    style: Theme.of(context).textTheme.headline4),
                const Text(
                    "Don't worry, any of your credentials won't be collected or shared with anyone"),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 400,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Spotify Client ID",
                          label: Text("ClientID"),
                        ),
                        onChanged: (value) {
                          setState(() {
                            client_id = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Spotify Client Secret",
                          label: Text("Client Secret"),
                        ),
                        onChanged: (value) {
                          setState(() {
                            client_secret = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          handleLogin(authState);
                        },
                        child: const Text("Submit"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
