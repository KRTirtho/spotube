import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'common.dart';

class WindowsBuildCommand extends Command with BuildCommandCommonSteps {
  @override
  String get description => "Build Windows exe";

  @override
  String get name => "windows";

  Future<void> innoDependInstall() async {
    final innoDependencyPath = join(cwd.path, "build", "inno-depend");

    await shell.run(
      "git clone https://github.com/DomGries/InnoDependencyInstaller.git $innoDependencyPath",
    );
  }

  @override
  void run() async {
    stdout.writeln("Replace versions");

    final chocoFiles = [
      join(cwd.path, "choco-struct", "tools", "VERIFICATION.txt"),
      join(cwd.path, "choco-struct", "spotube.nuspec"),
    ];

    for (final filePath in chocoFiles) {
      final file = File(filePath);
      final content = file.readAsStringSync();
      final newContent =
          content.replaceAll(versionVarRegExp, versionWithoutBuildNumber);

      file.writeAsStringSync(newContent);
    }

    await bootstrap();
    await innoDependInstall();

    final runnerRCFile = File(
      join(cwd.path, "windows", "runner", "Runner.rc"),
    );

    runnerRCFile.writeAsStringSync(
      runnerRCFile
          .readAsStringSync()
          .replaceAll("%{{SPOTUBE_VERSION}}%", versionWithoutBuildNumber)
          .replaceAll(
            "%{{SPOTUBE_VERSION_AS_NUMBER}}%",
            [
              pubspec.version!.major,
              pubspec.version!.minor,
              pubspec.version!.patch,
              0
            ].join(","),
          ),
    );

    await shell.run(
      "flutter_distributor package --platform=windows --targets=exe --skip-clean",
    );

    final ogExe = File(
      join(
        cwd.path,
        "dist",
        pubspec.version.toString(),
        "spotube-${pubspec.version}-windows-setup.exe",
      ),
    );

    final exePath = join(cwd.path, "dist", "Spotube-windows-x86_64-setup.exe");

    await ogExe.copy(exePath);
    await ogExe.delete();

    stdout.writeln("✅ Windows exe built at $exePath");

    final exeFile = File(exePath);

    final hash = sha256.convert(await exeFile.readAsBytes()).toString();

    final chocoVerificationFile = File(chocoFiles.first);

    chocoVerificationFile.writeAsStringSync(
      chocoVerificationFile.readAsStringSync().replaceAll(
            RegExp(r"\%\{\{WIN_SHA256\}\}\%"),
            hash,
          ),
    );

    await exeFile.copy(
      join(cwd.path, "choco-struct", "tools", basename(exeFile.path)),
    );

    await shell.run(
      "choco pack ${chocoFiles[1]}  --outputdirectory ${join(cwd.path, "dist")}",
    );

    final chocoNupkg = File(
      join(cwd.path, "dist", "spotube.$versionWithoutBuildNumber.nupkg"),
    );

    final distNupkgPath = join(
      cwd.path,
      "dist",
      "Spotube-windows-x86_64.nupkg",
    );

    await chocoNupkg.copy(distNupkgPath);
    await chocoNupkg.delete();

    stdout.writeln("✅ Windows nupkg built at $distNupkgPath");
  }
}
