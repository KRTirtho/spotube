import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class LocalLibrariesPage extends HookConsumerWidget {
  const LocalLibrariesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    // final blacklist = ref.watch(blacklistProvider);
    // final searchText = useState("");
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final preferences = ref.watch(userPreferencesProvider);

    final addLocalLibraryLocation = useCallback(() async {
      if (DesktopTools.platform.isMobile || DesktopTools.platform.isMacOS) {
        final dirStr = await FilePicker.platform.getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation, dirStr]);
      } else {
        String? dirStr = await getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation, dirStr]);
      }
    }, [preferences.localLibraryLocation]);

    final removeLocalLibraryLocation = useCallback((int index) {
      if (index < 0 || index >= preferences.localLibraryLocation.length) return;
      preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation]..removeAt(index));
    }, [preferences.localLibraryLocation]);

    return Scaffold(
      appBar: PageWindowTitleBar(
        title: Text(context.l10n.local_library),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => searchText.value = value,
              decoration: InputDecoration(
                hintText: context.l10n.search,
                prefixIcon: const Icon(SpotubeIcons.search),
              ),
            ),
          ), */
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              child: const Icon(SpotubeIcons.add),
              onPressed: addLocalLibraryLocation,
            ),
          ),
          InterScrollbar(
            controller: controller,
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              itemCount: preferences.localLibraryLocation.length,
              itemBuilder: (context, index) {
                final item = preferences.localLibraryLocation.elementAt(index);
                return ListTile(
                  title: Text(item),
                  trailing: Tooltip(
                    message: context.l10n.remove_library_location,
                    child: IconButton(
                      icon: Icon(SpotubeIcons.trash, color: Colors.red[400]),
                      onPressed: () => removeLocalLibraryLocation(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
