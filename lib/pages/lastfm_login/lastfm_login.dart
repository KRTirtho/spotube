import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/dialogs/prompt_dialog.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';

class LastFMLoginPage extends HookConsumerWidget {
  static const name = "lastfm_login";
  const LastFMLoginPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final router = GoRouter.of(context);
    final scrobblerNotifier = ref.read(scrobblerProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final username = useTextEditingController();
    final password = useTextEditingController();
    final passwordVisible = useState(false);

    final isLoading = useState(false);

    return Scaffold(
      appBar: const PageWindowTitleBar(leading: BackButton()),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(top: 8),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 186, 0, 0),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        SpotubeIcons.lastFm,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    Text(
                      "last.fm",
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(context.l10n.login_with_your_lastfm),
                    const SizedBox(height: 10),
                    AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            autofillHints: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            controller: username,
                            validator: ValidationBuilder().required().build(),
                            decoration: InputDecoration(
                              labelText: context.l10n.username,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            autofillHints: const [
                              AutofillHints.password,
                            ],
                            controller: password,
                            validator: ValidationBuilder().required().build(),
                            obscureText: !passwordVisible.value,
                            decoration: InputDecoration(
                              labelText: context.l10n.password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordVisible.value
                                      ? SpotubeIcons.eye
                                      : SpotubeIcons.noEye,
                                ),
                                onPressed: () => passwordVisible.value =
                                    !passwordVisible.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    FilledButton(
                      onPressed: isLoading.value
                          ? null
                          : () async {
                              try {
                                isLoading.value = true;
                                if (formKey.currentState?.validate() != true) {
                                  return;
                                }
                                await scrobblerNotifier.login(
                                  username.text.trim(),
                                  password.text,
                                );
                                router.pop();
                              } catch (e) {
                                if (context.mounted) {
                                  showPromptDialog(
                                    context: context,
                                    title: context.l10n
                                        .error("Authentication failed"),
                                    message: e.toString(),
                                    cancelText: null,
                                  );
                                }
                              } finally {
                                isLoading.value = false;
                              }
                            },
                      child: Text(context.l10n.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
