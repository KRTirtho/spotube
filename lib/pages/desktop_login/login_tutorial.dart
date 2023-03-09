import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/desktop_login/login_form.dart';
import 'package:spotube/components/shared/links/hyper_link.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/utils/service_utils.dart';

class LoginTutorial extends ConsumerWidget {
  const LoginTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(AuthenticationNotifier.provider);
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);
    final key = GlobalKey<State<IntroductionScreen>>();

    final pageDecoration = PageDecoration(
      bodyTextStyle: Theme.of(context).textTheme.bodyMedium!,
      titleTextStyle: Theme.of(context).textTheme.headlineMedium!,
    );
    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: TextButton(
          child: const Text("Exit"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: IntroductionScreen(
        key: key,
        globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        overrideBack: OutlinedButton(
          child: const Center(child: Text("Previous")),
          onPressed: () {
            (key.currentState as IntroductionScreenState).previous();
          },
        ),
        overrideNext: FilledButton(
          child: const Center(child: Text("Next")),
          onPressed: () {
            (key.currentState as IntroductionScreenState).next();
          },
        ),
        showBackButton: true,
        overrideDone: FilledButton(
          onPressed: authenticationNotifier.isLoggedIn
              ? () {
                  ServiceUtils.navigate(context, "/");
                }
              : null,
          child: const Center(child: Text("Done")),
        ),
        pages: [
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 1",
            image: Assets.tutorial.step1.image(),
            bodyWidget: Wrap(
              children: const [
                Text(
                  "First, Go to ",
                ),
                Hyperlink(
                  "accounts.spotify.com ",
                  "https://accounts.spotify.com",
                ),
                Text(
                  "and Login/Sign up if you're not logged in",
                ),
              ],
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 2",
            image: Assets.tutorial.step2.image(),
            bodyWidget: const Text(
              "1. Once you're logged in, press F12 or Mouse Right Click > Inspect to Open the Browser devtools.\n2. Then go the \"Application\" Tab (Chrome, Edge, Brave etc..) or \"Storage\" Tab (Firefox, Palemoon etc..)\n3. Go to the \"Cookies\" section then the \"https://accounts.spotify.com\" subsection",
              textAlign: TextAlign.left,
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 3",
            image: Assets.tutorial.step3.image(),
            bodyWidget: const Text(
              "Copy the values of \"sp_dc\" and \"sp_key\" Cookies",
              textAlign: TextAlign.left,
            ),
          ),
          if (authenticationNotifier.isLoggedIn)
            PageViewModel(
              decoration: pageDecoration.copyWith(
                bodyAlignment: Alignment.center,
              ),
              title: "Success🥳",
              image: Assets.success.image(),
              body:
                  "Now you're successfully Logged In with your Spotify account. Good Job, mate!",
            )
          else
            PageViewModel(
              decoration: pageDecoration,
              title: "Step 5",
              bodyWidget: Column(
                children: [
                  Text(
                    "Paste the copied \"sp_dc\" and \"sp_key\" values in the respective fields",
                    style: Theme.of(context).textTheme.labelMedium,
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
