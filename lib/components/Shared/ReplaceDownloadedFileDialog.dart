import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class ReplaceDownloadedFileDialog extends StatelessWidget {
  final Track track;
  const ReplaceDownloadedFileDialog({required this.track, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Track ${track.name} Already Exists"),
      content:
          const Text("Do you want to replace the already downloaded track?"),
      actions: [
        TextButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }
}
