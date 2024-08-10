import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/settings/settings.dart';

import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/utils/service_utils.dart';

class AnonymousFallback extends ConsumerWidget {
  final Widget? child;
  const AnonymousFallback({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    final isLoggedIn = ref.watch(authenticationProvider);

    if (isLoggedIn.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLoggedIn.asData?.value != null && child != null) return child!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.not_logged_in),
          const SizedBox(height: 10),
          FilledButton(
            child: Text(context.l10n.login_with_spotify),
            onPressed: () => ServiceUtils.pushNamed(context, SettingsPage.name),
          )
        ],
      ),
    );
  }
}
