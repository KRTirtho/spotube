import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:spotube/collections/env.dart';

import 'package:spotube/components/shared/links/anchor_button.dart';
import 'package:spotube/hooks/controllers/use_package_info.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
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
          : Version.parse(packageInfo.version);
      final latestVersion =
          tagName == "nightly" ? null : Version.parse(tagName);
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
    if (!Env.enableUpdateChecker) return;
    if (!isCheckUpdateEnabled) return null;
    checkUpdate().then((value) {
      final currentVersion = value.first;
      final latestVersion = value.last;
      if (currentVersion == null ||
          latestVersion == null ||
          (latestVersion.isPreRelease && !currentVersion.isPreRelease) ||
          (!latestVersion.isPreRelease && currentVersion.isPreRelease)) return;
      if (latestVersion <= currentVersion) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black26,
        builder: (context) {
          const url =
              "https://spotube.krtirtho.dev/other-downloads/stable-downloads";
          return AlertDialog(
            title: const Text("Spotube has an update"),
            actions: [
              FilledButton(
                child: const Text("Download Now"),
                onPressed: () => download(url),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Spotube v${value.last} has been released"),
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
        },
      );
    });
    return null;
  }, [packageInfo, isCheckUpdateEnabled]);
}
