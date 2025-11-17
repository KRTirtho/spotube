import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/logger/logger.dart';

class MetadataPluginScrobbleNotifier
    extends Notifier<StreamController<SpotubeTrackObject>?> {
  @override
  build() {
    final metadataPlugin = ref.watch(metadataPluginProvider);
    final pluginConfig = ref
        .watch(metadataPluginsProvider)
        .valueOrNull
        ?.defaultMetadataPluginConfig;

    if (metadataPlugin.valueOrNull == null ||
        pluginConfig == null ||
        !pluginConfig.abilities.contains(PluginAbilities.scrobbling)) {
      return null;
    }

    final controller = StreamController<SpotubeTrackObject>.broadcast();

    final subscription = controller.stream.listen((event) async {
      try {
        await metadataPlugin.valueOrNull?.core.scrobble({
          "id": event.id,
          "title": event.name,
          "artists": event.artists
              .map((artist) => {
                    "id": artist.id,
                    "name": artist.name,
                  })
              .toList(),
          "album": {
            "id": event.album.id,
            "name": event.album.name,
          },
          "timestamp": DateTime.now().millisecondsSinceEpoch ~/ 1000,
          "duration_ms": event.durationMs,
          "isrc": event is SpotubeFullTrackObject ? event.isrc : null,
        });
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });

    ref.onDispose(() {
      subscription.cancel();
      controller.close();
    });

    return controller;
  }

  void scrobble(SpotubeTrackObject track) {
    state?.add(track);
  }
}

final metadataPluginScrobbleProvider = NotifierProvider<
    MetadataPluginScrobbleNotifier, StreamController<SpotubeTrackObject>?>(
  MetadataPluginScrobbleNotifier.new,
);
