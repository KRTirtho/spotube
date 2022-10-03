import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/utils/service_utils.dart';

class TokenLoginForm extends HookConsumerWidget {
  final void Function()? onDone;
  const TokenLoginForm({
    Key? key,
    this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Auth authState = ref.watch(authProvider);
    final directCodeController = useTextEditingController();
    final keyCodeController = useTextEditingController();
    final mounted = useIsMounted();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        children: [
          TextField(
            controller: directCodeController,
            decoration: const InputDecoration(
              hintText: "Spotify \"sp_dc\" Cookie",
              label: Text("sp_dc Cookie"),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: keyCodeController,
            decoration: const InputDecoration(
              hintText: "Spotify \"sp_key\" Cookie",
              label: Text("sp_key Cookie"),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (keyCodeController.text.isEmpty ||
                  directCodeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill in all fields"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              final cookieHeader =
                  "sp_dc=${directCodeController.text}; sp_key=${keyCodeController.text}";
              final body = await ServiceUtils.getAccessToken(cookieHeader);

              authState.setAuthState(
                accessToken: body.accessToken,
                authCookie: cookieHeader,
                expiration: body.expiration,
              );
              if (mounted()) {
                onDone?.call();
              }
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
}
