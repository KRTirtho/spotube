import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/metadata_plugin/core/auth.dart';

import 'package:spotube/utils/platform.dart';

class AnonymousFallback extends ConsumerWidget {
  final Widget? child;
  const AnonymousFallback({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context, ref) {
    final isLoggedIn = ref.watch(metadataPluginAuthenticatedProvider);

    if (isLoggedIn.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isLoggedIn.asData?.value == true && child != null) return child!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          Undraw(
            illustration: kIsMobile
                ? UndrawIllustration.accessDenied
                : UndrawIllustration.secureLogin,
            height: 200 * context.theme.scaling,
            color: context.theme.colorScheme.primary,
          ),
          Text(context.l10n.not_logged_in),
          Button.primary(
            child: Text(context.l10n.login),
            onPressed: () => context.navigateTo(const SettingsRoute()),
          )
        ],
      ),
    );
  }
}
