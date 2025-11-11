import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';

final replaceDownloadedFileState = StateProvider<bool?>((ref) => null);

class ReplaceDownloadedDialog extends ConsumerWidget {
  final SpotubeTrackObject track;
  const ReplaceDownloadedDialog({required this.track, super.key});

  @override
  Widget build(BuildContext context, ref) {
    final replaceAll = ref.watch(replaceDownloadedFileState);

    return AlertDialog(
      title: Text(context.l10n.track_exists(track.name)),
      content: RadioGroup(
        value: replaceAll,
        onChanged: (value) {
          ref.read(replaceDownloadedFileState.notifier).state = value;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.do_you_want_to_replace),
            const Gap(16),
            RadioItem<bool>(
              value: true,
              trailing: Text(context.l10n.replace_downloaded_tracks),
            ),
            const Gap(8),
            RadioItem<bool>(
              value: false,
              trailing: Text(context.l10n.skip_download_tracks),
            ),
          ],
        ),
      ),
      actions: [
        Button.outline(
          onPressed: replaceAll == true
              ? null
              : () {
                  Navigator.pop(context, false);
                },
          child: Text(context.l10n.skip),
        ),
        Button.primary(
          onPressed: replaceAll == false
              ? null
              : () {
                  Navigator.pop(context, true);
                },
          child: Text(context.l10n.replace),
        ),
      ],
    );
  }
}
