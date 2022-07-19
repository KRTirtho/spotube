import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/utils/service_utils.dart';

class LoginForm extends HookConsumerWidget {
  final void Function()? onDone;
  LoginForm({this.onDone, Key? key}) : super(key: key);

  final log = getLogger(LoginForm);

  @override
  Widget build(BuildContext context, ref) {
    Auth authState = ref.watch(authProvider);
    final clientIdController = useTextEditingController();
    final clientSecretController = useTextEditingController();
    final fieldError = useState(false);

    Future handleLogin(Auth authState) async {
      try {
        if (clientIdController.value.text == "" ||
            clientSecretController.value.text == "") {
          fieldError.value = true;
        }
        await ServiceUtils.oauthLogin(
          ref.read(authProvider),
          clientId: clientIdController.value.text,
          clientSecret: clientSecretController.value.text,
        ).then(
          (value) => onDone?.call(),
        );
      } catch (e) {
        log.e("[Login.handleLogin] $e");
      }
    }

    return ConstrainedBox(
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
    );
  }
}
