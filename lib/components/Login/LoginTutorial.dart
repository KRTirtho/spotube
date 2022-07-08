import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:spotube/components/Login/LoginForm.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/provider/Auth.dart';

class LoginTutorial extends ConsumerWidget {
  const LoginTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);

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
        next: const Text("Next"),
        back: const Text("Previous"),
        showBackButton: true,
        overrideDone: TextButton(
          child: const Text("Done"),
          onPressed: auth.isLoggedIn
              ? () {
                  GoRouter.of(context).go("/");
                }
              : null,
        ),
        pages: [
          PageViewModel(
            title: "Step 1",
            image: CachedNetworkImage(
                imageUrl:
                    "https://user-images.githubusercontent.com/61944859/111762106-d1d37680-88ca-11eb-9884-ec7a40c0dd27.png"),
            bodyWidget: Wrap(
              children: [
                Text("First, Go to ",
                    style: Theme.of(context).textTheme.bodyText1),
                Hyperlink(
                  "developer.spotify.com/dashboard ",
                  "https://developer.spotify.com/dashboard",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                Text(
                  "and Login if you're not logged in",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          PageViewModel(
            title: "Step 2",
            image: CachedNetworkImage(
                imageUrl:
                    "https://user-images.githubusercontent.com/61944859/111762507-473f4700-88cb-11eb-91f3-d480e9584883.png"),
            bodyWidget: Text(
              "Now, create an Spotify Developer Application by Clicking on the \"CREATE AN APP\" button. Give it a name and description too",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          PageViewModel(
            title: "Step 3 [Really Important!]",
            bodyWidget: Column(
              children: [
                Text(
                  "Tap on the \"EDIT SETTINGS\" Button & navigate to \"Redirect URIs\" section",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Add",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextButton(
                      child: Text(
                        "http://localhost:4304/auth/spotify/callback",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                          const ClipboardData(
                            text: "http://localhost:4304/auth/spotify/callback",
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            width: 300,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              "Copied http://localhost:4304/auth/spotify/callback to clipboard",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "to \"Redirect URIs\"",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://user-images.githubusercontent.com/61944859/172991668-fa40f247-1118-4aba-a749-e669b732fa4d.jpg",
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://user-images.githubusercontent.com/61944859/111768971-d308a180-88d2-11eb-9108-3e7444cef049.png",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PageViewModel(
            title: "Step 4",
            image: CachedNetworkImage(
                imageUrl:
                    "https://user-images.githubusercontent.com/61944859/111769501-7fe31e80-88d3-11eb-8fc1-f3655dbd4711.png"),
            body:
                "Finally, reveal the \"Client Secret\" by clicking on the \"SHOW CLIENT SECRET\" text\n Copy the Client ID & Client Secret then Paste them in the next Screen",
          ),
          PageViewModel(
            title: "Step 5",
            bodyWidget: Column(
              children: [
                Text(
                  "Paste the Copied \"Client ID\" and \"Client Secret\" Here",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 10),
                LoginForm(),
              ],
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
            ),
        ],
      ),
    );
  }
}
