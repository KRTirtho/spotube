import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/mobile_login/hooks/login_callback.dart';
import 'package:spotube/services/kv_store/kv_store.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GettingStartedScreenSupportSection extends HookConsumerWidget {
  const GettingStartedScreenSupportSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final onLogin = useLoginCallback(ref);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSupportContent(context),
              const Gap(48),
              _buildActionButtons(context, ref, onLogin),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // const Icon(SpotubeIcons.heartFilled, color: Colors.pink),
            // const SizedBox(width: 8),
            Text(
              context.l10n.help_project_grow,
              style: const TextStyle(color: Colors.pink),
            ).semiBold(),
          ],
        ),
        const Gap(16),
        Text(context.l10n.help_project_grow_description),
        const Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildButton(
              label: context.l10n.contribute_on_github,
              icon: const Icon(
                SpotubeIcons.github,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              url: "https://github.com/KRTirtho/spotube",
            ),
            if (!Env.hideDonations) ...[
              const Gap(16),
              _buildButton(
                label: context.l10n.donate_on_open_collective,
                icon: const Icon(SpotubeIcons.openCollective),
                backgroundColor: Colors.blue,
                url: "https://opencollective.com/spotube",
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(
      BuildContext context, WidgetRef ref, Future<void> Function() onLogin) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: double.infinity,
            child: Button.secondary(
              leading: const Icon(SpotubeIcons.anonymous),
              onPressed: () async {
                await KVStoreService.setDoneGettingStarted(true);
                if (context.mounted) {
                  context.navigateTo(const HomeRoute());
                }
              },
              child: Text(context.l10n.browse_anonymously),
            ),
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: Button.primary(
              leading: const Icon(SpotubeIcons.spotify, color: Colors.white,),
              style: ButtonVariance.primary.copyWith(
                decoration: (context, states, value) {
                  return states.isNotEmpty
                      ? ButtonVariance.primary.decoration(context, states)
                      : BoxDecoration(
                          color: const Color(0xff1db954),
                          borderRadius: BorderRadius.circular(8),
                        );
                },
              ),
              onPressed: () async {
                await KVStoreService.setDoneGettingStarted(true);
                await onLogin();
              },
              child: Text(
                context.l10n.connect_with_spotify,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required Icon icon,
    required Color backgroundColor,
    required String url,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Button(
          leading: icon,
          style: ButtonVariance.primary.copyWith(
            decoration: (context, states, value) {
              return states.isNotEmpty
                  ? ButtonVariance.primary.decoration(context, states)
                  : BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    );
            },
          ),
          onPressed: () async {
            await launchUrlString(url, mode: LaunchMode.externalApplication);
          },
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
