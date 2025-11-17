import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

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

    stdout.writeln("✅ Built Android Apk and Appbundle");
  }
}
