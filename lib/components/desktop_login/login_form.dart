import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/extensions/context.dart';

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

    final isLoading = useState(false);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        children: [
          TextField(
            controller: directCodeController,
            decoration: InputDecoration(
              hintText: context.l10n.spotify_cookie("\"sp_dc\""),
              labelText: context.l10n.cookie_name_cookie("sp_dc"),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: keyCodeController,
            decoration: InputDecoration(
              hintText: context.l10n.spotify_cookie("\"sp_key (or sp_gaid)\""),
              labelText: context.l10n.cookie_name_cookie("sp_key (or sp_gaid)"),
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: isLoading.value
                ? null
                : () async {
                    try {
                      isLoading.value = true;
                      if (keyCodeController.text.isEmpty ||
                          directCodeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.fill_in_all_fields),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      final cookieHeader =
                          "sp_dc=${directCodeController.text.trim()}; sp_key=${keyCodeController.text.trim()}";

                      authenticationNotifier.setCredentials(
                        await AuthenticationCredentials.fromCookie(
                            cookieHeader),
                      );
                      if (mounted()) {
                        onDone?.call();
                      }
                    } finally {
                      isLoading.value = false;
                    }
                  },
            child: Text(context.l10n.submit),
          )
        ],
      ),
    );
  }
}
