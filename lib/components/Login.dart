import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Login extends HookConsumerWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var clientIdController = useTextEditingController();
    var clientSecretController = useTextEditingController();
    var accessTokenController = useTextEditingController();
    var fieldError = useState(false);

    Future handleLogin(Auth authState) async {
      try {
        if (clientIdController.value.text == "" ||
            clientSecretController.value.text == "") {
          fieldError.value = true;
        }
        await oauthLogin(
          ref.read(authProvider),
          clientId: clientIdController.value.text,
          clientSecret: clientSecretController.value.text,
        );
      } catch (e) {
        print("[Login.handleLogin] $e");
      }
    }

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
                      controller: clientIdController,
                      decoration: const InputDecoration(
                        hintText: "Spotify Client ID",
                        label: Text("ClientID"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Spotify Client Secret",
                        label: Text("Client Secret"),
                      ),
                      controller: clientSecretController,
                    ),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        label: Text("Genius Access Token (optional)"),
                      ),
                      controller: accessTokenController,
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
                        preferences.setGeniusAccessToken(
                            accessTokenController.value.text);
                        await localStorage.setString(
                            LocalStorageKeys.geniusAccessToken,
                            accessTokenController.value.text);
                        accessTokenController.text = "";
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
