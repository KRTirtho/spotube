import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Login/TokenLoginForms.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/utils/service_utils.dart';

class TokenLogin extends HookConsumerWidget {
  const TokenLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
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
                  TokenLoginForm(
                    onDone: () => GoRouter.of(context).go("/"),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text("Don't know how to do this?"),
                      TextButton(
                        child: const Text(
                          "Follow along the Step by Step guide",
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
