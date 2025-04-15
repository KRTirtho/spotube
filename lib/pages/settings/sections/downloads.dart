import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

import '../../../components/adaptive/adaptive_select_tile.dart';
import '../../../models/database/database.dart';

class SettingsDownloadsSection extends HookConsumerWidget {
  const SettingsDownloadsSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final preferences = ref.watch(userPreferencesProvider);

    final pickDownloadLocation = useCallback(() async {
      if (kIsMobile || kIsMacOS) {
        final dirStr = await FilePicker.platform.getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        preferencesNotifier.setDownloadLocation(dirStr);
      } else {
        String? dirStr = await getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        preferencesNotifier.setDownloadLocation(dirStr);
      }
    }, [preferences.downloadLocation]);

    return SectionCardWithHeading(
      heading: context.l10n.downloads,
      children: [
        ListTile(
          leading: const Icon(SpotubeIcons.download),
          title: Text(context.l10n.download_location),
          subtitle: Text(preferences.downloadLocation),
          trailing: IconButton.secondary(
            onPressed: pickDownloadLocation,
            icon: const Icon(SpotubeIcons.folder),
          ),
          onTap: pickDownloadLocation,
        ),
        AdaptiveSelectTile<FileNameFormat>(
          secondary: const Icon(SpotubeIcons.file),
          title: Text(context.l10n.file_name_format),
          value: preferences.fileNameFormat,
          options: [
            SelectItemButton(
              value: FileNameFormat.titleArtists,
              child: Text("${context.l10n.title} - ${context.l10n.artists}"),
            ),
            SelectItemButton(
              value: FileNameFormat.artistsTitle,
              child: Text("${context.l10n.artists} - ${context.l10n.title}"),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              preferencesNotifier.setFileNameFormat(value);
            }
          },
        ),
      ],
    );
  }
}
