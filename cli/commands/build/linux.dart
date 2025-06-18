import 'dart:async';
import 'dart:io';

import 'package:io/io.dart';
import 'package:args/command_runner.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../../core/env.dart';
import 'common.dart';

class LinuxBuildCommand extends Command with BuildCommandCommonSteps {
  @override
  String get description => "Linux build command";

  @override
  String get name => "linux";

  @override
  FutureOr? run() async {
    stdout.writeln("Replacing versions");

    final appDataFile = File(
      join(cwd.path, "linux", "com.github.KRTirtho.Spotube.appdata.xml"),
    );

    appDataFile.writeAsStringSync(
      appDataFile.readAsStringSync().replaceAll(
            versionVarRegExp,
            '<release'
            ' version="$versionWithoutBuildNumber"'
            ' date="${DateFormat("yyyy-MM-dd").format(DateTime.now())}"'
            '/>',
          ),
    );

    await bootstrap();

    await shell.run(
      "flutter_distributor package --platform=linux --targets=deb",
    );

    if (architecture == "x86") {
      await shell.run(
        "flutter_distributor package --platform=linux --targets=rpm",
      );
    }

    final tempDir = join(Directory.systemTemp.path, "spotube-tar");
    final bundleArchName = architecture == "x86" ? "x86_64" : "aarch64";
    final bundleDirPath = join(
      cwd.path,
      "build",
      "linux",
      architecture == "x86" ? "x64" : architecture,
      "release",
      "bundle",
    );

    final tarFile = File(join(
      cwd.path,
      "dist",
      "spotube-linux-"
          "${CliEnv.channel == BuildChannel.nightly ? "nightly" : versionWithoutBuildNumber}"
          "-$bundleArchName.tar.xz",
    ));

    await copyPath(bundleDirPath, tempDir);
    await File(join(cwd.path, "linux", "spotube.desktop")).copy(
      join(tempDir, "spotube.desktop"),
    );
    await File(
      join(cwd.path, "linux", "com.github.KRTirtho.Spotube.appdata.xml"),
    ).copy(
      join(tempDir, "com.github.KRTirtho.Spotube.appdata.xml"),
    );
    await File(join(cwd.path, "assets", "spotube-logo.png")).copy(
      join(tempDir, "spotube-logo.png"),
    );

    await shell.run(
      "tar -cJf ${tarFile.path} -C $tempDir .",
    );

    final ogDeb = File(
      join(
        cwd.path,
        "dist",
        pubspec.version.toString(),
        "spotube-${pubspec.version}-linux.deb",
      ),
    );
    await ogDeb.copy(
      join(
        cwd.path,
        "dist",
        "Spotube-linux-$bundleArchName.deb",
      ),
    );
    await ogDeb.delete();

    if (architecture == "x86") {
      final ogRpm = File(
        join(
          cwd.path,
          "dist",
          pubspec.version.toString(),
          "spotube-${pubspec.version}-linux.rpm",
        ),
      );

      await ogRpm.copy(
        join(cwd.path, "dist", "Spotube-linux-$bundleArchName.rpm"),
      );

      await ogRpm.delete();
    }

    stdout.writeln("✅ Linux building done");
  }
}
