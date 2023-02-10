import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/provider/authentication_provider.dart';

class TokenLoginForm extends HookConsumerWidget {
  final void Function()? onDone;
  const TokenLoginForm({
    Key? key,
    this.onDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);
    final directCodeController = useTextEditingController();
    final keyCodeController = useTextEditingController();
    final mounted = useIsMounted();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        children: [
          PlatformTextField(
            controller: directCodeController,
            placeholder: "Spotify \"sp_dc\" Cookie",
            label: "sp_dc Cookie",
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 10),
          PlatformTextField(
            controller: keyCodeController,
            placeholder: "Spotify \"sp_key\" Cookie",
            label: "sp_key Cookie",
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 20),
          PlatformFilledButton(
            onPressed: () async {
              if (keyCodeController.text.isEmpty ||
                  directCodeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: PlatformText("Please fill in all fields"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              final cookieHeader =
                  "sp_dc=${directCodeController.text}; sp_key=${keyCodeController.text}";

              authenticationNotifier.setCredentials(
                await AuthenticationCredentials.fromCookie(cookieHeader),
              );
              if (mounted()) {
                onDone?.call();
              }
            },
            child: const PlatformText("Submit"),
          )
        ],
      ),
    );
  }
}
