import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Login/LoginForm.dart';
import 'package:spotube/components/Shared/Hyperlink.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/Logger.dart';

class Login extends HookConsumerWidget {
  Login({Key? key}) : super(key: key);
  final log = getLogger(Login);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const PageWindowTitleBar(leading: BackButton()),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Image.asset(
                  "assets/spotube-logo.png",
                  width: MediaQuery.of(context).size.width *
                      (breakpoint <= Breakpoints.md ? .5 : .3),
                ),
                Text("Add your spotify credentials to get started",
                    style: breakpoint <= Breakpoints.md
                        ? textTheme.headline5
                        : textTheme.headline4),
                Text(
                  "Don't worry, any of your credentials won't be collected or shared with anyone",
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 10),
                LoginForm(
                  onDone: () => GoRouter.of(context).pop(),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text("Don't know how to do this?"),
                    TextButton(
                      child: const Text(
                        "Follow along the Step by Step guid",
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
    );
  }
}
