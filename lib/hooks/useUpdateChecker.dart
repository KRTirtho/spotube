import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Home/Sidebar.dart';
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
      final currentVersion = value.first;
      final latestVersion = value.last;
      if (currentVersion == null || latestVersion == null) return;
      if (latestVersion <= currentVersion) return;
      showPlatformAlertDialog(context, builder: (context) {
        const url =
            "https://spotube.netlify.app/other-downloads/stable-downloads";
        return PlatformAlertDialog(
          macosAppIcon: Sidebar.brandLogo(),
          title: const PlatformText("Spotube has an update"),
          primaryActions: [
            PlatformFilledButton(
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
                  const PlatformText("Read the latest "),
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
