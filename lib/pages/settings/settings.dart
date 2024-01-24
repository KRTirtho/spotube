import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
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

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(context.l10n.settings),
          centerTitle: true,
        ),
        body: Scrollbar(
          controller: controller,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1366),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: ListView(
                  controller: controller,
                  children: [
                    const SettingsAccountSection(),
                    const SettingsLanguageRegionSection(),
                    const SettingsAppearanceSection(),
                    const SettingsPlaybackSection(),
                    const SettingsDownloadsSection(),
                    if (DesktopTools.platform.isDesktop)
                      const SettingsDesktopSection(),
                    if (!kIsWeb) const SettingsDevelopersSection(),
                    const SettingsAboutSection(),
                    Center(
                      child: FilledButton(
                        onPressed: preferencesNotifier.reset,
                        child: Text(context.l10n.restore_defaults),
                      ),
                    ),
                    const SizedBox(height: 10),
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
