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
      "fastforge package --platform=linux --targets=deb,appimage",
    );
    if (architecture == "x86") {
      await shell.run(
        "fastforge package --platform=linux --targets=rpm",
      );
    }

    // fastforge's AppRun puts the bundled Mesa (usr/lib) ahead of the system
    // GL stack, which breaks EGL/GL context creation on distros with newer
    // DRI drivers (e.g. Linux Mint 22.3) and makes the app SIGSEGV
    // immediately on startup. Patch the generated AppImage so the system
    // GL stack wins and bundled libs only act as a fallback.
    await _fixAppImageAppRun();

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
    await File(join(cwd.path, "assets", "branding", "spotube-logo.png")).copy(
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

    final ogAppImage = File(
      join(
        cwd.path,
        "dist",
        pubspec.version.toString(),
        "spotube-${pubspec.version}-linux.AppImage",
      ),
    );
    await ogAppImage.copy(
      join(
        cwd.path,
        "dist",
        "Spotube-linux-$bundleArchName.AppImage",
      ),
    );
    await ogAppImage.delete();

    stdout.writeln("✅ Linux building done");
  }

  Future<void> _fixAppImageAppRun() async {
    final ogAppImage = File(
      join(
        cwd.path,
        "dist",
        pubspec.version.toString(),
        "spotube-${pubspec.version}-linux.AppImage",
      ),
    );
    if (!ogAppImage.existsSync()) {
      stdout.writeln(
        "[fixAppImageAppRun] AppImage not found at ${ogAppImage.path}; skipping",
      );
      return;
    }

    final workDir = join(Directory.systemTemp.path, "spotube-appimage-fix");
    await shell.run(
      "rm -rf '$workDir' && mkdir -p '$workDir'"
      " && cd '$workDir'"
      " && '${ogAppImage.path}' --appimage-extract",
    );

    final appRun = File(join(workDir, "squashfs-root", "AppRun"));
    if (!appRun.existsSync()) {
      stdout.writeln("[fixAppImageAppRun] AppRun not found; skipping");
      return;
    }

    final hostTriple =
        architecture == "x86" ? "x86_64-linux-gnu" : "aarch64-linux-gnu";
    final fixedAppRun = r'''#!/bin/bash
APPDIR="$(cd "$(dirname "$0")" && pwd)"
# System GL stack first, bundled libs only as fallback.
# Keeping bundled Mesa ahead of the system stack breaks EGL/GL context
# creation on distros with newer DRI drivers (e.g. Linux Mint 22.3).
export LD_LIBRARY_PATH="/lib/HOST_TRIPLE:/usr/lib/HOST_TRIPLE:$APPDIR/usr/lib:$APPDIR/lib"
cd "$APPDIR"
exec ./spotube
'''.replaceAll("HOST_TRIPLE", hostTriple);
    await appRun.writeAsString(fixedAppRun);
    await shell.run("chmod +x '${appRun.path}'");

    final appimagetoolPath =
        File(join(Directory.systemTemp.path, "appimagetool.AppImage"));
    if (!appimagetoolPath.existsSync()) {
      final archTag = architecture == "x86" ? "x86_64" : "aarch64";
      await shell.run(
        "curl -L --fail -o '${appimagetoolPath.path}'"
        " 'https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-$archTag.AppImage'",
      );
      await shell.run("chmod +x '${appimagetoolPath.path}'");
    }

    await shell.run(
      "cd '$workDir'"
      " && '${appimagetoolPath.path}' --appimage-extract-and-run"
      " squashfs-root '${ogAppImage.path}'",
    );

    await Directory(workDir).delete(recursive: true);
    stdout.writeln(
      "[fixAppImageAppRun] AppRun patched in ${ogAppImage.path}",
    );
  }
}
