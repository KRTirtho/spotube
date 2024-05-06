import 'package:args/command_runner.dart';

import 'commands/build.dart';
import 'commands/install-dependencies.dart';

void main(List<String> args) {
  final commandRunner = CommandRunner(
    "cli",
    "Configuration CLI for Spotube",
  );

  commandRunner.addCommand(InstallDependenciesCommand());
  commandRunner.addCommand(BuildCommand());

  commandRunner.run(args);
}
