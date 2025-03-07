import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Material, MaterialType;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/settings/sections/about.dart';
import 'package:spotube/pages/settings/sections/accounts.dart';
import 'package:spotube/pages/settings/sections/appearance.dart';
import 'package:spotube/pages/settings/sections/desktop.dart';
import 'package:spotube/pages/settings/sections/developers.dart';
import 'package:spotube/pages/settings/sections/downloads.dart';
import 'package:spotube/pages/settings/sections/language_region.dart';
import 'package:spotube/pages/settings/sections/playback.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class SettingsPage extends HookConsumerWidget {
  static const name = "settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          TitleBar(
            title: Text(context.l10n.settings),
          )
        ],
        child: Scrollbar(
          controller: controller,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1366),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: Material(
                  type: MaterialType.transparency,
                  child: ListView(
                    controller: controller,
                    children: [
                      const SettingsAccountSection(),
                      const SettingsLanguageRegionSection(),
                      const SettingsAppearanceSection(),
                      const SettingsPlaybackSection(),
                      const SettingsDownloadsSection(),
                      if (kIsDesktop) const SettingsDesktopSection(),
                      if (!kIsWeb) const SettingsDevelopersSection(),
                      const SettingsAboutSection(),
                      Center(
                        child: Button.destructive(
                          onPressed: preferencesNotifier.reset,
                          child: Text(context.l10n.restore_defaults),
                        ),
                      ),
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
