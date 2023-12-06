import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class Discord {
  final DiscordRPC? discordRPC;

  Discord()
      : discordRPC =
            DesktopTools.platform.isWindows || DesktopTools.platform.isLinux
                ? DiscordRPC(applicationId: Env.discordAppId)
                : null {
    discordRPC?.start(autoRegister: true);
  }

  void updatePresence(Track track) {
    clear();
    final artistNames =
        TypeConversionUtils.artists_X_String(track.artists ?? <Artist>[]);
    discordRPC?.updatePresence(
      DiscordPresence(
        details: "Song: ${track.name} by $artistNames",
        state: "Vibing in Music",
        startTimeStamp: DateTime.now().millisecondsSinceEpoch,
        largeImageKey: "spotube-logo-foreground",
        largeImageText: "Spotube",
        smallImageKey: "spotube-logo-foreground",
        smallImageText: "Spotube",
      ),
    );
  }

  void clear() {
    discordRPC?.clearPresence();
  }

  void shutdown() {
    discordRPC?.shutDown();
  }
}

final discord = Discord();
