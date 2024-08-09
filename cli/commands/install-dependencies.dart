import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:process_run/shell_run.dart';

class InstallDependenciesCommand extends Command {
  @override
  String get description => "Install platform dependencies";

  @override
  String get name => "install-dependencies";

  InstallDependenciesCommand() {
    argParser.addOption(
      "platform",
      abbr: "p",
      allowed: [
        "windows",
        "linux",
        "linux_arm",
        "macos",
        "ios",
        "android",
      ],
      mandatory: true,
    );
  }

  @override
  FutureOr? run() async {
    final shell = Shell();

    switch (argResults!.option("platform")) {
      case "windows":
        break;
      case "linux":
        await shell.run(
          """
          sudo apt-get update -y
          sudo apt-get install -y tar clang cmake ninja-build pkg-config libgtk-3-dev make python3-pip python3-setuptools desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse libunwind-dev locate patchelf gir1.2-appindicator3-0.1 libappindicator3-1 libappindicator3-dev libsecret-1-0 libjsoncpp25 libsecret-1-dev libjsoncpp-dev libnotify-bin libnotify-dev mpv libmpv-dev libwebkit2gtk-4.1-0 libwebkit2gtk-4.1-dev libsoup-3.0-0 libsoup-3.0-dev
          """,
        );
        break;
      case "linux_arm":
        await shell.run(
          """
          sudo apt-get update -y
          sudo apt-get install -y pkg-config make python3-pip python3-setuptools
          """,
        );
        break;
      case "macos":
        await shell.run(
          """
          brew install python-setuptools
          npm install -g appdmg
          """,
        );
        break;
      case "ios":
        await shell.run(
          """
          rustup target add aarch64-apple-ios
          """,
        );
        break;
      case "android":
        await shell.run(
          """
          sudo apt-get update -y
          sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev make python3-pip python3-setuptools patchelf desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse
          """,
        );
        break;
      default:
        break;
    }
  }
}
