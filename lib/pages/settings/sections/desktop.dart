import 'package:flutter/material.dart' show ListTile;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class SettingsDesktopSection extends HookConsumerWidget {
  const SettingsDesktopSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);

    return SectionCardWithHeading(
      heading: context.l10n.desktop,
      children: [
        const Gap(10),
        AdaptiveSelectTile<CloseBehavior>(
          secondary: const Icon(SpotubeIcons.close),
          title: Text(context.l10n.close_behavior),
          value: preferences.closeBehavior,
          options: [
            SelectItemButton(
              value: CloseBehavior.close,
              child: Text(context.l10n.close),
            ),
            SelectItemButton(
              value: CloseBehavior.minimizeToTray,
              child: Text(context.l10n.minimize_to_tray),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              preferencesNotifier.setCloseBehavior(value);
            }
          },
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.tray),
          title: Text(context.l10n.show_tray_icon),
          trailing: Switch(
            value: preferences.showSystemTrayIcon,
            onChanged: preferencesNotifier.setShowSystemTrayIcon,
          ),
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.window),
          title: Text(context.l10n.use_system_title_bar),
          trailing: Switch(
            value: preferences.systemTitleBar,
            onChanged: preferencesNotifier.setSystemTitleBar,
          ),
        ),
        ListTile(
          leading: const Icon(SpotubeIcons.discord),
          title: Text(context.l10n.discord_rich_presence),
          trailing: Switch(
            value: preferences.discordPresence,
            onChanged: preferencesNotifier.setDiscordPresence,
          ),
        ),
      ],
    );
  }
}
