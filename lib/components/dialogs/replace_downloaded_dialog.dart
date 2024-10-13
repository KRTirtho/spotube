import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/context.dart';

final replaceDownloadedFileState = StateProvider<bool?>((ref) => null);

class ReplaceDownloadedDialog extends ConsumerWidget {
  final Track track;
  const ReplaceDownloadedDialog({required this.track, super.key});

  @override
  Widget build(BuildContext context, ref) {
    final groupValue = ref.watch(replaceDownloadedFileState);
    final theme = Theme.of(context);
    final replaceAll = ref.watch(replaceDownloadedFileState);

    return AlertDialog(
      title: Text(context.l10n.track_exists(track.name ?? "")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.do_you_want_to_replace),
          RadioListTile<bool>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
            value: true,
            groupValue: groupValue,
            onChanged: (value) {
              if (value != null) {
                ref.read(replaceDownloadedFileState.notifier).state = true;
              }
            },
            title: Text(context.l10n.replace_downloaded_tracks),
          ),
          RadioListTile<bool>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: theme.colorScheme.primary,
            value: false,
            groupValue: groupValue,
            onChanged: (value) {
              if (value != null) {
                ref.read(replaceDownloadedFileState.notifier).state = false;
              }
            },
            title: Text(context.l10n.skip_download_tracks),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          onPressed: replaceAll == true
              ? null
              : () {
                  Navigator.pop(context, false);
                },
          child: Text(context.l10n.skip),
        ),
        FilledButton(
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
