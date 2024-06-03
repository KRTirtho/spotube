import 'dart:io';

enum BuildChannel {
  stable,
  nightly;

  factory BuildChannel.fromEnvironment(String name) {
    final channel = Platform.environment[name]!;
    if (channel == "stable") {
      return BuildChannel.stable;
    } else if (channel == "nightly") {
      return BuildChannel.nightly;
    } else {
      throw Exception("Invalid channel: $channel");
    }
  }
}

class CliEnv {
  static final channel = BuildChannel.fromEnvironment("CHANNEL");
  static final dotenv = Platform.environment["DOTENV"]!;
  static final ghRunNumber = Platform.environment["GITHUB_RUN_NUMBER"];
  static final flutterVersion = Platform.environment["FLUTTER_VERSION"]!;
}
