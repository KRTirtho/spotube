import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';

import '../../core/env.dart';
import 'common.dart';

class AndroidBuildCommand extends Command with BuildCommandCommonSteps {
  @override
  String get description => "Build for android";

  @override
  String get name => "android";

  @override
  FutureOr? run() async {
    await bootstrap();

    await shell.run(
      "flutter build apk --flavor ${CliEnv.channel.name}",
    );

    await dotEnvFile.writeAsString(
      "\nENABLE_UPDATE_CHECK=0"
      "\nHIDE_DONATIONS=1",
      mode: FileMode.append,
    );

    final androidManifestFile = File(
        join(cwd.path, "android", "app", "src", "main", "AndroidManifest.xml"));

    final androidManifestXml =
        XmlDocument.parse(await androidManifestFile.readAsString());

    final deletingElement =
        androidManifestXml.findAllElements("meta-data").firstWhereOrNull(
              (el) =>
                  el.getAttribute("android:name") ==
                  "com.google.android.gms.car.application",
            );

    deletingElement?.parent?.children.remove(deletingElement);

    await androidManifestFile.writeAsString(
      androidManifestXml.toXmlString(pretty: true),
    );

    await shell.run(
      """
      dart run build_runner clean
      dart run build_runner build --delete-conflicting-outputs
      flutter build appbundle --flavor ${CliEnv.channel.name}
      """,
    );

    final ogApkFile = File(
      join(
        "build",
        "app",
        "outputs",
        "flutter-apk",
        "app-${CliEnv.channel.name}-release.apk",
      ),
    );

    await ogApkFile.copy(
      join(cwd.path, "build", "Spotube-android-all-arch.apk"),
    );

    final ogAppbundleFile = File(
      join(
        cwd.path,
        "build",
        "app",
        "outputs",
        "bundle",
        "${CliEnv.channel.name}Release",
        "app-${CliEnv.channel.name}-release.aab",
      ),
    );

    await ogAppbundleFile.copy(
      join(cwd.path, "build", "Spotube-playstore-all-arch.aab"),
    );

    stdout.writeln("✅ Built Android Apk and Appbundle");
  }
}
