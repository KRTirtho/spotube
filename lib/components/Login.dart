import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotube/components/Home.dart';
import 'package:spotube/components/PageWindowTitleBar.dart';
import 'package:spotube/helpers/server_ipc.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String clientId = "";
  String clientSecret = "";
  bool _fieldError = false;
  String? accessToken;
  String? refreshToken;
  DateTime? expiration;

  handleLogin(Auth authState) async {
    try {
      if (clientId == "" || clientSecret == "") {
        return setState(() {
          _fieldError = true;
        });
      }
      final credentials = SpotifyApiCredentials(clientId, clientSecret);
      final grant = SpotifyApi.authorizationCodeGrant(credentials);
      const redirectUri = "http://localhost:4304/auth/spotify/callback";

      final authUri = grant.getAuthorizationUrl(Uri.parse(redirectUri),
          scopes: spotifyScopes);

      final responseUri = await connectIpc(authUri.toString(), redirectUri);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if (responseUri != null) {
        final SpotifyApi spotify =
            SpotifyApi.fromAuthCodeGrant(grant, responseUri);
        var credentials = await spotify.getCredentials();
        if (credentials.accessToken != null) {
          accessToken = credentials.accessToken;
          await localStorage.setString(
              LocalStorageKeys.accessToken, credentials.accessToken!);
        }
        if (credentials.refreshToken != null) {
          refreshToken = credentials.refreshToken;
          await localStorage.setString(
              LocalStorageKeys.refreshToken, credentials.refreshToken!);
        }
        if (credentials.expiration != null) {
          expiration = credentials.expiration;
          await localStorage.setString(LocalStorageKeys.expiration,
              credentials.expiration?.toString() ?? "");
        }
      }

      await localStorage.setString(LocalStorageKeys.clientId, clientId);
      await localStorage.setString(
        LocalStorageKeys.clientSecret,
        clientSecret,
      );
      authState.setAuthState(
        clientId: clientId,
        clientSecret: clientSecret,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiration: expiration,
        isLoggedIn: true,
      );
    } catch (e) {
      print("[Login.handleLogin] $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authState, child) {
        return Scaffold(
          body: Column(
            children: [
              const PageWindowTitleBar(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/spotube-logo.png",
                        width: 400,
                        height: 400,
                      ),
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
                                  clientId = value;
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
                                  clientSecret = value;
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
              ),
            ],
          ),
        );
      },
    );
  }
}
