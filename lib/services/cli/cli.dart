// ignore_for_file: avoid_print

import 'dart:io';

import 'package:args/args.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<ArgResults> startCLI(List<String> args) async {
  final parser = ArgParser();

  parser.addFlag(
    'verbose',
    abbr: 'v',
    help: 'Verbose mode',
    defaultsTo: !kReleaseMode,
  );
  parser.addFlag(
    "version",
    help: "Print version and exit",
    negatable: false,
  );

  parser.addFlag("help", abbr: "h", negatable: false);

  final arguments = parser.parse(args);

  if (arguments["help"] == true) {
    print(parser.usage);
    exit(0);
  }

  if (arguments["version"] == true) {
    final package = await PackageInfo.fromPlatform();
    print("Spotube v${package.version}");
    exit(0);
  }

  return arguments;
}
