import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class Discord extends ChangeNotifier {
  final DiscordRPC? discordRPC;
  final bool isEnabled;

  Discord(this.isEnabled)
      : discordRPC = (DesktopTools.platform.isWindows ||
                    DesktopTools.platform.isLinux) &&
                isEnabled
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

  @override
  void dispose() {
    clear();
    shutdown();
    super.dispose();
  }
}

final discordProvider = ChangeNotifierProvider(
  (ref) {
    final isEnabled =
        ref.watch(userPreferencesProvider.select((s) => s.discordPresence));
    final playback = ref.read(ProxyPlaylistNotifier.provider);
    final discord = Discord(isEnabled);

    if (playback.activeTrack != null) {
      discord.updatePresence(playback.activeTrack!);
    }

    return discord;
  },
);
