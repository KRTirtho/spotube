import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/desktop_login/login_form.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/mobile_login/mobile_login.dart';

class DesktopLoginPage extends HookConsumerWidget {
  static const name = WebViewLogin.name;
  const DesktopLoginPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final color = theme.colorScheme.surfaceVariant.withOpacity(.3);

    return SafeArea(
      child: Scaffold(
        appBar: const PageWindowTitleBar(
          leading: BackButton(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Assets.spotubeLogoPng.image(
                    width: MediaQuery.of(context).size.width *
                        (mediaQuery.mdAndDown ? .5 : .3),
                  ),
                  Text(
                    context.l10n.add_spotify_credentials,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    context.l10n.credentials_will_not_be_shared_disclaimer,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  TokenLoginForm(
                    onDone: () => GoRouter.of(context).go("/"),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(context.l10n.know_how_to_login),
                      TextButton(
                        child: Text(
                          context.l10n.follow_step_by_step_guide,
                        ),
                        onPressed: () => GoRouter.of(context).push(
                          "/login-tutorial",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
