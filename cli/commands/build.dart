import 'package:args/command_runner.dart';

import 'build/android.dart';
import 'build/ios.dart';
import 'build/linux.dart';
import 'build/linux_arm.dart';
import 'build/macos.dart';
import 'build/windows.dart';

class BuildCommand extends Command {
  @override
  String get description => "Build for different platforms";

  @override
  String get name => "build";

  BuildCommand() {
    addSubcommand(AndroidBuildCommand());
    addSubcommand(IosBuildCommand());
    addSubcommand(LinuxBuildCommand());
    addSubcommand(LinuxArmBuildCommand());
    addSubcommand(MacosBuildCommand());
    addSubcommand(WindowsBuildCommand());
  }
}
