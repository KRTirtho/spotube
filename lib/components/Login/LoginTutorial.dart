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

    return Scaffold(
      appBar: PageWindowTitleBar(
        leading: PlatformTextButton(
          child: const Text("Exit"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: IntroductionScreen(
        next: const Text("Next"),
        back: const Text("Previous"),
        showBackButton: true,
        overrideDone: PlatformTextButton(
          onPressed: auth.isLoggedIn
              ? () {
                  ServiceUtils.navigate(context, "/");
                }
              : null,
          child: const Text("Done"),
        ),
        pages: [
          PageViewModel(
            title: "Step 1",
            image: Image.asset("assets/tutorial/step-1.png"),
            bodyWidget: Wrap(
              children: [
                Text(
                  "First, Go to ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Hyperlink(
                  "accounts.spotify.com ",
                  "https://accounts.spotify.com",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                Text(
                  "and Login/Sign up if you're not logged in",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          PageViewModel(
            title: "Step 2",
            image: Image.asset("assets/tutorial/step-2.png"),
            bodyWidget: Text(
              "1. Once you're logged in, press F12 or Mouse Right Click > Inspect to Open the Browser devtools.\n2. Then go the \"Application\" Tab (Chrome, Edge, Brave etc..) or \"Storage\" Tab (Firefox, Palemoon etc..)\n3. Go to the \"Cookies\" section then the \"https://accounts.spotify.com\" subsection",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          PageViewModel(
            title: "Step 3",
            image: Image.asset(
              "assets/tutorial/step-3.png",
            ),
            bodyWidget: Text(
              "Copy the values of \"sp_dc\" and \"sp_key\" Cookies",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
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
                children: [
                  Text(
                    "Paste the copied \"sp_dc\" and \"sp_key\" values in the respective fields",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 10),
                  const TokenLoginForm(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
