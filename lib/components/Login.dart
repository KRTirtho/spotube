import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/provider/Auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String clientId = "";
  String clientSecret = "";
  bool _fieldError = false;

  handleLogin(Auth authState) async {
    try {
      if (clientId == "" || clientSecret == "") {
        return setState(() {
          _fieldError = true;
        });
      }
      await oauthLogin(context, clientId: clientId, clientSecret: clientSecret);
    } catch (e) {
      print("[Login.handleLogin] $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, authState, child) {
        return Scaffold(
          appBar: const PageWindowTitleBar(),
          body: Center(
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
        );
      },
    );
  }
}
