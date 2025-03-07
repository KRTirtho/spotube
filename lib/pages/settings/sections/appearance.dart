import 'package:flutter/material.dart' show ListTile;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/modules/settings/color_scheme_picker_dialog.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class SettingsAppearanceSection extends HookConsumerWidget {
  final bool isGettingStarted;
  const SettingsAppearanceSection({
    super.key,
    this.isGettingStarted = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final pickColorScheme = useCallback(() {
      return () => showDialog(
          context: context,
          builder: (context) {
            return const ColorSchemePickerDialog();
          });
    }, []);

    final children = [
      AdaptiveSelectTile<LayoutMode>(
        secondary: const Icon(SpotubeIcons.dashboard),
        title: Text(context.l10n.layout_mode),
        subtitle: Text(context.l10n.override_layout_settings),
        value: preferences.layoutMode,
        onChanged: (value) {
          if (value != null) {
            preferencesNotifier.setLayoutMode(value);
          }
        },
        options: [
          SelectItemButton(
            value: LayoutMode.adaptive,
            child: Text(context.l10n.adaptive),
          ),
          SelectItemButton(
            value: LayoutMode.compact,
            child: Text(context.l10n.compact),
          ),
          SelectItemButton(
            value: LayoutMode.extended,
            child: Text(context.l10n.extended),
          ),
        ],
      ),
      AdaptiveSelectTile<ThemeMode>(
        secondary: const Icon(SpotubeIcons.darkMode),
        title: Text(context.l10n.theme),
        value: preferences.themeMode,
        options: [
          SelectItemButton(
            value: ThemeMode.dark,
            child: Text(context.l10n.dark),
          ),
          SelectItemButton(
            value: ThemeMode.light,
            child: Text(context.l10n.light),
          ),
          SelectItemButton(
            value: ThemeMode.system,
            child: Text(context.l10n.system),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            preferencesNotifier.setThemeMode(value);
          }
        },
      ),
      // ListTile(
      //     leading: const Icon(SpotubeIcons.amoled),
      //     title: Text(context.l10n.use_amoled_mode),
      //     subtitle: Text(context.l10n.pitch_dark_theme),
      //     trailing: Switch(
      //       value: preferences.amoledDarkTheme,
      //       onChanged: preferencesNotifier.setAmoledDarkTheme,
      //     )),
      ListTile(
        leading: const Icon(SpotubeIcons.palette),
        title: Text(context.l10n.accent_color),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        trailing: ColorChip(
          color: preferences.accentColorScheme,
          name: preferences.accentColorScheme.name,
          onPressed: pickColorScheme(),
          isActive: false,
        ),
        onTap: pickColorScheme(),
      ),
      // ListTile(
      //     leading: const Icon(SpotubeIcons.colorSync),
      //     title: Text(context.l10n.sync_album_color),
      //     subtitle: Text(context.l10n.sync_album_color_description),
      //     trailing: Switch(
      //       value: preferences.albumColorSync,
      //       onChanged: preferencesNotifier.setAlbumColorSync,
      //     )),
    ];

    if (isGettingStarted) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final child in children) ...[
            child,
            const Gap(16),
          ],
        ],
      );
    }

    return SectionCardWithHeading(
      heading: context.l10n.appearance,
      children: children,
    );
  }
}
