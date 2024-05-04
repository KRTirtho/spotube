import 'package:flutter/material.dart';
import 'package:spotube/components/shared/links/anchor_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

class RootAppUpdateDialog extends StatelessWidget {
  final Version? version;
  const RootAppUpdateDialog({super.key, this.version});

  @override
  Widget build(BuildContext context) {
    const url = "https://spotube.krtirtho.dev/downloads";
    return AlertDialog(
      title: const Text("Spotube has an update"),
      actions: [
        FilledButton(
          child: const Text("Download Now"),
          onPressed: () => launchUrlString(
            url,
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Spotube v$version has been released"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Read the latest "),
              AnchorButton(
                "release notes",
                style: const TextStyle(color: Colors.blue),
                onTap: () => launchUrlString(
                  url,
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
