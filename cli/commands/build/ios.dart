import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

import '../../core/env.dart';
import 'common.dart';

class IosBuildCommand extends Command with BuildCommandCommonSteps {
  @override
  String get description => "iOS build command";

  @override
  String get name => "ios";

  @override
  FutureOr? run() async {
    await bootstrap();

    final buildDirPath = join(cwd.path, "build", "ios", "iphoneos");
    await shell.run(
      """
      flutter build ios --release --no-codesign --flavor ${CliEnv.channel.name}
      ln -sf $buildDirPath Payload
      zip -r9 Spotube-iOS.ipa ${join("Payload", "${CliEnv.channel.name}.app")}
      """,
    );
  }
}
