import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/desktop_login/login_form.dart';
import 'package:spotube/components/shared/links/hyper_link.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/utils/service_utils.dart';

class LoginTutorial extends ConsumerWidget {
  static const name = "login_tutorial";
  const LoginTutorial({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(authenticationProvider);
    final authenticationNotifier = ref.watch(authenticationProvider.notifier);
    final key = GlobalKey<State<IntroductionScreen>>();
    final theme = Theme.of(context);

    final pageDecoration = PageDecoration(
      bodyTextStyle: theme.textTheme.bodyMedium!,
      titleTextStyle: theme.textTheme.headlineMedium!,
    );
    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: TextButton(
          child: Text(context.l10n.exit),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: IntroductionScreen(
        key: key,
        globalBackgroundColor: theme.scaffoldBackgroundColor,
        overrideBack: OutlinedButton(
          child: Center(child: Text(context.l10n.previous)),
          onPressed: () {
            (key.currentState as IntroductionScreenState).previous();
          },
        ),
        overrideNext: FilledButton(
          child: Center(child: Text(context.l10n.next)),
          onPressed: () {
            (key.currentState as IntroductionScreenState).next();
          },
        ),
        showBackButton: true,
        overrideDone: FilledButton(
          onPressed: authenticationNotifier.isLoggedIn
              ? () {
                  ServiceUtils.pushNamed(context, HomePage.name);
                }
              : null,
          child: Center(child: Text(context.l10n.done)),
        ),
        pages: [
          PageViewModel(
            decoration: pageDecoration,
            title: context.l10n.step_1,
            image: Assets.tutorial.step1.image(),
            bodyWidget: Wrap(
              children: [
                Text(context.l10n.first_go_to),
                const SizedBox(width: 5),
                const Hyperlink(
                  "accounts.spotify.com ",
                  "https://accounts.spotify.com",
                ),
                Text(context.l10n.login_if_not_logged_in),
              ],
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: context.l10n.step_2,
            image: Assets.tutorial.step2.image(),
            bodyWidget:
                Text(context.l10n.step_2_steps, textAlign: TextAlign.left),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: context.l10n.step_3,
            image: Assets.tutorial.step3.image(),
            bodyWidget:
                Text(context.l10n.step_3_steps, textAlign: TextAlign.left),
          ),
          if (authenticationNotifier.isLoggedIn)
            PageViewModel(
              decoration: pageDecoration.copyWith(
                bodyAlignment: Alignment.center,
              ),
              title: context.l10n.success_emoji,
              image: Assets.success.image(),
              body: context.l10n.success_message,
            )
          else
            PageViewModel(
              decoration: pageDecoration,
              title: context.l10n.step_4,
              bodyWidget: Column(
                children: [
                  Text(
                    context.l10n.step_4_steps,
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 10),
                  TokenLoginForm(
                    onDone: () {
                      GoRouter.of(context).go("/");
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
