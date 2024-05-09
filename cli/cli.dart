import 'package:args/command_runner.dart';

import 'commands/build.dart';
import 'commands/credits.dart';
import 'commands/install-dependencies.dart';
import 'commands/translated.dart';
import 'commands/untranslated.dart';

void main(List<String> args) {
  final commandRunner = CommandRunner(
    "cli",
    "Configuration CLI for Spotube",
  );

  commandRunner.addCommand(InstallDependenciesCommand());
  commandRunner.addCommand(BuildCommand());
  commandRunner.addCommand(CreditsCommand());
  commandRunner.addCommand(TranslatedCommand());
  commandRunner.addCommand(UntranslatedCommand());

  commandRunner.run(args);
}
