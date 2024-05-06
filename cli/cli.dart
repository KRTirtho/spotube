import 'package:args/command_runner.dart';

void main(List<String> args) {
  final commandRunner = CommandRunner(
    "cli",
    "Configuration CLI for Spotube",
  );

  commandRunner.run(args);
}
