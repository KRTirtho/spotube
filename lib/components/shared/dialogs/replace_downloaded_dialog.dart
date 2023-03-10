import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spotify/spotify.dart';

final replaceDownloadedFileState = StateProvider<bool?>((ref) => null);

class ReplaceDownloadedDialog extends ConsumerWidget {
  final Track track;
  const ReplaceDownloadedDialog({required this.track, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final groupValue = ref.watch(replaceDownloadedFileState);

    return AlertDialog(
      title: Text("Track ${track.name} Already Exists"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Do you want to replace the already downloaded track?"),
          RadioListTile<bool>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
            value: true,
            groupValue: groupValue,
            onChanged: (value) {
              if (value != null) {
                ref.read(replaceDownloadedFileState.notifier).state = value;
              }
            },
            title: const Text("Replace all downloaded tracks"),
          ),
          RadioListTile<bool>(
            dense: true,
            contentPadding: EdgeInsets.zero,
            activeColor: Theme.of(context).primaryColor,
            value: false,
            groupValue: groupValue,
            onChanged: (value) {
              if (value != null) {
                ref.read(replaceDownloadedFileState.notifier).state = value;
              }
            },
            title: const Text("Skip downloading all downloaded tracks"),
          ),
        ],
      ),
      actions: [
        OutlinedButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FilledButton(
          child: const Text("Yes"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
