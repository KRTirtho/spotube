import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

class Discord extends ChangeNotifier {
  final DiscordRPC? discordRPC;
  final bool isEnabled;

  Discord(this.isEnabled)
      : discordRPC = (kIsWindows || kIsLinux) && isEnabled
            ? DiscordRPC(applicationId: Env.discordAppId)
            : null {
    discordRPC?.start(autoRegister: true);
  }

  void updatePresence(Track track) {
    clear();
    final artistNames = track.artists?.asString() ?? "";
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
    final playback = ref.read(proxyPlaylistProvider);
    final discord = Discord(isEnabled);

    if (playback.activeTrack != null) {
      discord.updatePresence(playback.activeTrack!);
    }

    return discord;
  },
);
