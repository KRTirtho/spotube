import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:spotube/components/Shared/AnchorButton.dart';
import 'package:spotube/hooks/usePackageInfo.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:version/version.dart';

void useUpdateChecker(WidgetRef ref) {
  final isCheckUpdateEnabled =
      ref.watch(userPreferencesProvider.select((s) => s.checkUpdate));
  final packageInfo = usePackageInfo(
    appName: 'Spotube',
    packageName: 'spotube',
  );
  final Future<List<Version?>> Function() checkUpdate = useCallback(
    () async {
      final value = await http.get(
        Uri.parse(
            "https://api.github.com/repos/KRTirtho/spotube/releases/latest"),
      );
      final tagName =
          (jsonDecode(value.body)["tag_name"] as String).replaceAll("v", "");
      final currentVersion = packageInfo.version == "Unknown"
          ? null
          : Version.parse(
              packageInfo.version,
            );
      final latestVersion = Version.parse(tagName);
      return [currentVersion, latestVersion];
    },
    [packageInfo.version],
  );

  final context = useContext();

  download(String url) => launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );

  useEffect(() {
    if (!isCheckUpdateEnabled) return null;
    checkUpdate().then((value) {
      if (value.first == null) return;
      if (value.first! <= value.last) return;
      showDialog(
          context: context,
          builder: (context) {
            final url =
                "https://github.com/KRTirtho/spotube/releases/tag/v${value.last}";
            return AlertDialog(
              title: const Text("Spotube has an update"),
              actions: [
                ElevatedButton(
                  child: const Text("Download Now"),
                  onPressed: () => download(url),
                ),
              ],
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Spotube v${value.last} has been released"),
                  Row(
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
          });
    });
    return null;
  }, [packageInfo, isCheckUpdateEnabled]);
}
