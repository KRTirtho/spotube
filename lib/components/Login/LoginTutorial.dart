import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Login/TokenLoginForms.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/utils/service_utils.dart';

class LoginTutorial extends ConsumerWidget {
  const LoginTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    final key = GlobalKey<State<IntroductionScreen>>();

    return PlatformScaffold(
      appBar: PageWindowTitleBar(
        leading: PlatformTextButton(
          child: const PlatformText("Exit"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: IntroductionScreen(
        key: key,
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
            title: "Step 1",
            image: Image.asset("assets/tutorial/step-1.png"),
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
            title: "Step 2",
            image: Image.asset("assets/tutorial/step-2.png"),
            bodyWidget: const PlatformText(
              "1. Once you're logged in, press F12 or Mouse Right Click > Inspect to Open the Browser devtools.\n2. Then go the \"Application\" Tab (Chrome, Edge, Brave etc..) or \"Storage\" Tab (Firefox, Palemoon etc..)\n3. Go to the \"Cookies\" section then the \"https://accounts.spotify.com\" subsection",
              textAlign: TextAlign.left,
            ),
          ),
          PageViewModel(
            title: "Step 3",
            image: Image.asset(
              "assets/tutorial/step-3.png",
            ),
            bodyWidget: const PlatformText(
              "Copy the values of \"sp_dc\" and \"sp_key\" Cookies",
              textAlign: TextAlign.left,
            ),
          ),
          if (auth.isLoggedIn)
            PageViewModel(
              decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
              ),
              title: "Success🥳",
              image: Image.asset("assets/success.png"),
              body:
                  "Now you're successfully Logged In with your Spotify account. Good Job, mate!",
            )
          else
            PageViewModel(
              title: "Step 5",
              bodyWidget: Column(
                children: const [
                  PlatformText(
                    "Paste the copied \"sp_dc\" and \"sp_key\" values in the respective fields",
                  ),
                  SizedBox(height: 10),
                  TokenLoginForm(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
