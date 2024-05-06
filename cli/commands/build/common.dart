import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:process_run/shell_run.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

mixin BuildCommandCommonSteps on Command {
  final shell = Shell();
  Directory get cwd => Directory.current;

  Pubspec? _pubspec;

  Pubspec get pubspec {
    if (_pubspec != null) {
      return _pubspec!;
    }

    final pubspecFile = File(join(cwd.path, "pubspec.yaml"));
    _pubspec = Pubspec.parse(pubspecFile.readAsStringSync());

    return _pubspec!;
  }

  String get versionWithoutBuildNumber {
    return "${pubspec.version!.major}.${pubspec.version!.minor}.${pubspec.version!.patch}";
  }

  RegExp get versionVarRegExp =>
      RegExp(r"\%\{\{SPOTUBE_VERSION\}\}\%", multiLine: true);

  Future<void> bootstrap() async {
    await shell.run(
      """
      flutter pub get
      dart run build_runner build --delete-conflicting-outputs
      dart pub global activate flutter_distributor
      """,
    );
  }
}
