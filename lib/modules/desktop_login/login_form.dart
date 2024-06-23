import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:puppeteer/protocol/network.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/authentication_provider.dart';

class TokenLoginForm extends HookConsumerWidget {
  final void Function()? onDone;
  const TokenLoginForm({
    super.key,
    this.onDone,
  });

  @override
  Widget build(BuildContext context, ref) {
    final authenticationNotifier = ref.watch(authenticationProvider.notifier);
    final directCodeController = useTextEditingController();
    final platform = Theme.of(context).platform;
    final isDesktop =
        platform == TargetPlatform.linux || platform == TargetPlatform.windows;

    final isLoading = useState(false);
    final showManualConf = useState(false);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Visibility(
              visible: showManualConf.value,
              child: Column(
                children: [
                  TextField(
                    controller: directCodeController,
                    decoration: InputDecoration(
                      hintText: context.l10n.spotify_cookie("\"sp_dc\""),
                      labelText: context.l10n.cookie_name_cookie("sp_dc"),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: isLoading.value
                        ? null
                        : () async {
                            try {
                              isLoading.value = true;
                              if (directCodeController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(context.l10n.fill_in_all_fields),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              final cookieHeader =
                                  "sp_dc=${directCodeController.text.trim()}";

                              authenticationNotifier.setCredentials(
                                await AuthenticationCredentials.fromCookie(
                                    cookieHeader),
                              );
                              if (context.mounted) {
                                onDone?.call();
                              }
                            } finally {
                              isLoading.value = false;
                            }
                          },
                    child: Text(context.l10n.submit),
                  )
                ],
              )),
          Visibility(
              visible: isDesktop && !showManualConf.value,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              final browser =
                                  await puppeteer.launch(headless: false);
                              try {
                                List<Cookie> cookies = [];
                                final page = await browser.newPage();

                                await page.goto(
                                    'https://accounts.spotify.com/en/login',
                                    wait: Until.domContentLoaded);

                                while (browser.isConnected) {
                                  cookies = await page.cookies();
                                  for (final cookie in cookies) {
                                    if (cookie.name == "sp_dc") {
                                      await browser.close();
                                      final cookieHeader =
                                          "sp_dc=${cookie.value.trim()}";

                                      authenticationNotifier.setCredentials(
                                        await AuthenticationCredentials
                                            .fromCookie(cookieHeader),
                                      );

                                      if (context.mounted) {
                                        onDone?.call();
                                      }

                                      return;
                                    }
                                  }
                                }
                              } catch (_) {
                                showManualConf.value = true;
                              } finally {
                                isLoading.value = false;
                                await browser.close();
                              }
                            },
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      child: Text(context.l10n.continue_in_browser),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
