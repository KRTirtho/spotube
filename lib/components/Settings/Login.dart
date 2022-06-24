import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/oauth-login.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';

class Login extends HookConsumerWidget {
  Login({Key? key}) : super(key: key);
  final log = getLogger(Login);

  @override
  Widget build(BuildContext context, ref) {
    Auth authState = ref.watch(authProvider);
    final clientIdController = useTextEditingController();
    final clientSecretController = useTextEditingController();
    final fieldError = useState(false);
    final breakpoint = useBreakpoints();

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
        ).then(
          (value) => GoRouter.of(context).pop(),
        );
      } catch (e) {
        log.e("[Login.handleLogin] $e");
      }
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const PageWindowTitleBar(leading: BackButton()),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Image.asset(
                  "assets/spotube-logo.png",
                  width: MediaQuery.of(context).size.width *
                      (breakpoint <= Breakpoints.md ? .5 : .3),
                ),
                Text("Add your spotify credentials to get started",
                    style: breakpoint <= Breakpoints.md
                        ? textTheme.headline5
                        : textTheme.headline4),
                const Text(
                    "Don't worry, any of your credentials won't be collected or shared with anyone"),
                const Hyperlink("How to get these client-id & client-secret?",
                    "https://github.com/KRTirtho/spotube#optional-configurations"),
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
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: clientSecretController,
                        decoration: const InputDecoration(
                          hintText: "Spotify Client Secret",
                          label: Text("Client Secret"),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await handleLogin(authState);
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
      ),
    );
  }
}
