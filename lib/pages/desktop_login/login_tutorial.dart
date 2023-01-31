import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/desktop_login/login_form.dart';
import 'package:spotube/components/shared/links/hyper_link.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/utils/service_utils.dart';

class LoginTutorial extends ConsumerWidget {
  const LoginTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    final key = GlobalKey<State<IntroductionScreen>>();

    final pageDecoration = PageDecoration(
      bodyTextStyle: PlatformTheme.of(context).textTheme!.body!,
      titleTextStyle: PlatformTheme.of(context).textTheme!.subheading!,
    );
    return PlatformScaffold(
      appBar: PageWindowTitleBar(
        hideWhenWindows: false,
        leading: PlatformTextButton(
          child: const PlatformText("Exit"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: IntroductionScreen(
        key: key,
        globalBackgroundColor:
            PlatformTheme.of(context).scaffoldBackgroundColor,
        overrideBack: PlatformFilledButton(
          isSecondary: true,
          child: const Center(child: PlatformText("Previous")),
          onPressed: () {
            (key.currentState as IntroductionScreenState).previous();
          },
        ),
        overrideNext: PlatformFilledButton(
          child: const Center(child: PlatformText("Next")),
          onPressed: () {
            (key.currentState as IntroductionScreenState).next();
          },
        ),
        showBackButton: true,
        overrideDone: PlatformFilledButton(
          onPressed: auth.isLoggedIn
              ? () {
                  ServiceUtils.navigate(context, "/");
                }
              : null,
          child: const Center(child: PlatformText("Done")),
        ),
        pages: [
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 1",
            image: Assets.tutorial.step1.image(),
            bodyWidget: Wrap(
              children: const [
                PlatformText(
                  "First, Go to ",
                ),
                Hyperlink(
                  "accounts.spotify.com ",
                  "https://accounts.spotify.com",
                ),
                PlatformText(
                  "and Login/Sign up if you're not logged in",
                ),
              ],
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 2",
            image: Assets.tutorial.step2.image(),
            bodyWidget: const PlatformText(
              "1. Once you're logged in, press F12 or Mouse Right Click > Inspect to Open the Browser devtools.\n2. Then go the \"Application\" Tab (Chrome, Edge, Brave etc..) or \"Storage\" Tab (Firefox, Palemoon etc..)\n3. Go to the \"Cookies\" section then the \"https://accounts.spotify.com\" subsection",
              textAlign: TextAlign.left,
            ),
          ),
          PageViewModel(
            decoration: pageDecoration,
            title: "Step 3",
            image: Assets.tutorial.step3.image(),
            bodyWidget: const PlatformText(
              "Copy the values of \"sp_dc\" and \"sp_key\" Cookies",
              textAlign: TextAlign.left,
            ),
          ),
          if (auth.isLoggedIn)
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
                  PlatformText.label(
                    "Paste the copied \"sp_dc\" and \"sp_key\" values in the respective fields",
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
