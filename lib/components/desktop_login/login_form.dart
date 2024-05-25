import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/authentication_provider.dart';

class TokenLoginForm extends HookConsumerWidget {
  final void Function()? onDone;
  const TokenLoginForm({
    super.key,
    this.onDone,
  });

  @override
  Widget build(BuildContext context, ref) {
    final authenticationNotifier = ref.watch(authenticationProvider.notifier);
    final directCodeController = useTextEditingController();

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
          FilledButton(
            onPressed: isLoading.value
                ? null
                : () async {
                    try {
                      isLoading.value = true;
                      if (directCodeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.fill_in_all_fields),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      final cookieHeader =
                          "sp_dc=${directCodeController.text.trim()}";

                      authenticationNotifier.setCredentials(
                        await AuthenticationCredentials.fromCookie(
                            cookieHeader),
                      );
                      if (context.mounted) {
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
