import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show ListTile;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/scrobbler/scrobbler.dart';

class SettingsAccountSection extends HookConsumerWidget {
  const SettingsAccountSection({super.key});

  @override
  Widget build(context, ref) {
    final scrobbler = ref.watch(scrobblerProvider);

    return SectionCardWithHeading(
      heading: context.l10n.account,
      children: [
        ListTile(
          leading: const Icon(SpotubeIcons.extensions),
          title: Text(context.l10n.plugins),
          subtitle: Text(context.l10n.configure_plugins),
          onTap: () {
            context.pushRoute(const SettingsMetadataProviderRoute());
          },
          trailing: const Icon(SpotubeIcons.angleRight),
        ),
        if (scrobbler.asData?.value == null)
          ListTile(
            leading: const Icon(SpotubeIcons.music),
            title: Text(context.l10n.audio_scrobblers),
            onTap: () {
              context.pushRoute(const SettingsScrobblingRoute());
            },
            trailing: const Icon(SpotubeIcons.angleRight),
          )
        else
          ListTile(
            leading: const Icon(SpotubeIcons.lastFm),
            title: Text(context.l10n.disconnect_lastfm),
            trailing: Button.destructive(
              onPressed: () {
                ref.read(scrobblerProvider.notifier).logout();
              },
              child: Text(context.l10n.disconnect),
            ),
          ),
      ],
    );
  }
}
