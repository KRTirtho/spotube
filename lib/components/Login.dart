import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  String clientId = "";
  String clientSecret = "";
  String accessToken = "";
  bool _fieldError = false;

  Future handleLogin(Auth authState) async {
    try {
      if (clientId == "" || clientSecret == "") {
        return setState(() {
          _fieldError = true;
        });
      }
      await oauthLogin(ref.read(authProvider),
          clientId: clientId, clientSecret: clientSecret);
    } catch (e) {
      print("[Login.handleLogin] $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Auth authState = ref.watch(authProvider);
    return Scaffold(
      appBar: const PageWindowTitleBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
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
              const Hyperlink("How to get these client-id & client-secret?",
                  "https://github.com/KRTirtho/spotube#configuration"),
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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text("Genius Access Token (optional)"),
                      ),
                      onChanged: (value) {
                        setState(() {
                          accessToken = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await handleLogin(authState);
                        UserPreferences preferences =
                            ref.read(userPreferencesProvider);
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        preferences.setGeniusAccessToken(accessToken);
                        await localStorage.setString(
                            LocalStorageKeys.geniusAccessToken, accessToken);
                        setState(() {
                          accessToken = "";
                        });
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
    );
  }
}
