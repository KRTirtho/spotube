import 'package:flutter/material.dart';
import 'package:spotube/components/shared/links/anchor_button.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

class RootAppUpdateDialog extends StatelessWidget {
  final Version? version;
  final int? nightlyBuildNum;

  const RootAppUpdateDialog({super.key, this.version}) : nightlyBuildNum = null;
  const RootAppUpdateDialog.nightly({super.key, required this.nightlyBuildNum})
      : version = null;

  @override
  Widget build(BuildContext context) {
    const url = "https://spotube.krtirtho.dev/downloads";
    const nightlyUrl = "https://spotube.krtirtho.dev/downloads/nightly";
    return AlertDialog(
      title: const Text("Spotube has an update"),
      actions: [
        FilledButton(
          child: const Text("Download Now"),
          onPressed: () => launchUrlString(
            nightlyBuildNum != null ? nightlyUrl : url,
            mode: LaunchMode.externalApplication,
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nightlyBuildNum != null
                ? "Spotube Nightly $nightlyBuildNum has been released"
                : "Spotube v$version has been released",
          ),
          if (nightlyBuildNum == null)
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
