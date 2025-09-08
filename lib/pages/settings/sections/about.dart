import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' show ListTile;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide ButtonStyle;
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_list_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsAboutSection extends HookConsumerWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);

    return SectionCardWithHeading(
      heading: context.l10n.about,
      children: [
        if (!Env.hideDonations)
          AdaptiveListTile(
            leading: const Icon(
              SpotubeIcons.heart,
              color: Colors.pink,
            ),
            title: SizedBox(
              height: 50,
              width: 200,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  context.l10n.u_love_spotube,
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            trailing: (context, update) => Button(
              style: ButtonVariance.primary.copyWith(
                decoration: (context, states, value) {
                  final decoration = ButtonVariance.primary
                      .decoration(context, states) as BoxDecoration;

                  if (states.contains(WidgetState.hovered)) {
                    return decoration.copyWith(color: Colors.pink[400]);
                  } else if (states.contains(WidgetState.focused)) {
                    return decoration.copyWith(color: Colors.pink[300]);
                  } else if (states.isNotEmpty) {
                    return decoration;
                  }

                  return decoration.copyWith(color: Colors.pink);
                },
                textStyle: (context, states, value) => ButtonVariance.primary
                    .textStyle(context, states)
                    .copyWith(color: Colors.white),
              ),
              onPressed: () {
                launchUrlString(
                  "https://opencollective.com/spotube",
                  mode: LaunchMode.externalApplication,
                );
              },
              leading: const Icon(SpotubeIcons.heart),
              child: Text(context.l10n.please_sponsor),
            ),
          ),
        if (Env.enableUpdateChecker)
          ListTile(
            leading: const Icon(SpotubeIcons.update),
            title: Text(context.l10n.check_for_updates),
            trailing: Switch(
              value: preferences.checkUpdate,
              onChanged: (checked) =>
                  preferencesNotifier.setCheckUpdate(checked),
            ),
          ),
        ListTile(
          leading: const Icon(SpotubeIcons.info),
          title: Text(context.l10n.about_spotube),
          trailing: const Icon(SpotubeIcons.angleRight),
          onTap: () {
            context.navigateTo(const AboutSpotubeRoute());
          },
        )
      ],
    );
  }
}
