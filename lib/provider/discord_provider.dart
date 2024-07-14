import 'dart:async';

import 'package:flutter_discord_rpc/flutter_discord_rpc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';

class DiscordNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() async {
    final enabled =
        ref.read(userPreferencesProvider.select((s) => s.discordPresence && kIsDesktop));
    final playback = ref.read(audioPlayerProvider);

    final subscription =
        FlutterDiscordRPC.instance.isConnectedStream.listen((connected) async {
      if (connected && playback.activeTrack != null) {
        await updatePresence(playback.activeTrack!);
      }
    });

    ref.onDispose(() async {
      subscription.cancel();
      await close();
      await FlutterDiscordRPC.instance.dispose();
    });

    if (!enabled && FlutterDiscordRPC.instance.isConnected) {
      await close();
    } else {
      await FlutterDiscordRPC.instance.connect(autoRetry: true);
    }
  }

  Future<void> updatePresence(Track track) async {
    await clear();
    final artistNames = track.artists?.asString() ?? "";
    await FlutterDiscordRPC.instance.setActivity(
      activity: RPCActivity(
        details: "${track.name} by $artistNames",
        state: "Vibing in Music",
        assets: const RPCAssets(
          largeImage: "spotube-logo-foreground",
          largeText: "Spotube",
          smallImage: "spotube-logo-foreground",
          smallText: "Spotube",
        ),
        buttons: [
          RPCButton(
            label: "Listen on Spotify",
            url: track.externalUrls?.spotify ??
                "https://open.spotify.com/tracks/${track.id}",
          ),
        ],
        timestamps: RPCTimestamps(
          start: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  Future<void> clear() async {
    await FlutterDiscordRPC.instance.clearActivity();
  }

  Future<void> close() async {
    await FlutterDiscordRPC.instance.disconnect();
  }
}

final discordProvider =
    AsyncNotifierProvider<DiscordNotifier, void>(() => DiscordNotifier());
