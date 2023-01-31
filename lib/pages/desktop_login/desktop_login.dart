import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/desktop_login/login_form.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/hooks/use_breakpoints.dart';

class DesktopLoginPage extends HookConsumerWidget {
  const DesktopLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();

    return SafeArea(
      child: PlatformScaffold(
        appBar: PageWindowTitleBar(
          leading: const PlatformBackButton(),
          hideWhenWindows: false,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: PlatformTheme.of(context).secondaryBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Assets.spotubeLogoPng.image(
                    width: MediaQuery.of(context).size.width *
                        (breakpoint <= Breakpoints.md ? .5 : .3),
                  ),
                  PlatformText.subheading(
                    "Add your spotify credentials to get started",
                  ),
                  PlatformText.label(
                    "Don't worry, any of your credentials won't be collected or shared with anyone",
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
                      const PlatformText("Don't know how to do this?"),
                      PlatformTextButton(
                        child: const PlatformText(
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
