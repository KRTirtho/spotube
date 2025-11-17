import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/metadata_plugins/plugin_update_available_dialog.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/provider/metadata_plugin/updater/update_checker.dart';
import 'package:spotube/provider/server/routes/connect.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/connectivity_adapter.dart';
import 'package:spotube/utils/service_utils.dart';

void useGlobalSubscriptions(WidgetRef ref) {
  final context = useContext();
  final theme = Theme.of(context);
  final connectRoutes = ref.watch(serverConnectRoutesProvider);

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ServiceUtils.checkForUpdates(context, ref);

      final pluginUpdate =
          await ref.read(metadataPluginUpdateCheckerProvider.future);

      if (pluginUpdate != null) {
        final pluginConfig = await ref.read(metadataPluginsProvider.future);
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => MetadataPluginUpdateAvailableDialog(
              plugin: pluginConfig.defaultMetadataPluginConfig!,
              update: pluginUpdate,
            ),
          );
        }
      }
    });

    StreamSubscription? audioPlayerSubscription;
    bool pausedByStream = false;

    final subscriptions = [
      ConnectionCheckerService.instance.onConnectivityChanged
          .listen((connected) async {
        audioPlayerSubscription?.cancel();

        /// Pausing or resuming based on connectivity to avoid MPV skipping
        /// audio while retrying to connect
        if (audioPlayer.currentIndex >= 0) {
          if (connected && audioPlayer.isPaused && pausedByStream) {
            await audioPlayer.resume();
            pausedByStream = false;
          } else if (!connected && audioPlayer.isPlaying) {
            if ((audioPlayer.bufferedPosition - const Duration(seconds: 1)) <=
                audioPlayer.position) {
              await audioPlayer.pause();
              pausedByStream = true;
            } else {
              audioPlayerSubscription =
                  audioPlayer.positionStream.listen((position) async {
                if (ConnectionCheckerService.instance.isConnectedSync) return;

                final bufferedPosition =
                    audioPlayer.bufferedPosition - const Duration(seconds: 1);
                final duration =
                    audioPlayer.duration - const Duration(seconds: 1);

                if (bufferedPosition <= position || position >= duration) {
                  audioPlayer.pause();
                  pausedByStream = true;
                }
              });
            }
          }
        }

        // Show notification for connection related issues
        if (!context.mounted) return;

        showToast(
          context: context,
          location: ToastLocation.bottomCenter,
          builder: (context, overlay) {
            if (connected) {
              return SurfaceCard(
                child: Basic(
                  leading: const Icon(SpotubeIcons.wifi),
                  title: Text(context.l10n.connection_restored),
                ),
              );
            }

            return SurfaceCard(
              fillColor: theme.colorScheme.destructive,
              filled: true,
              child: Basic(
                leading: Icon(
                  SpotubeIcons.noWifi,
                  color: theme.colorScheme.destructiveForeground,
                ),
                trailing: Text(
                  context.l10n.you_are_offline,
                  style: TextStyle(
                    color: theme.colorScheme.destructiveForeground,
                  ),
                ),
              ),
            );
          },
        );
      }),
      connectRoutes.connectClientStream.listen((clientOrigin) {
        if (!context.mounted) return;
        showToast(
          context: context,
          location: ToastLocation.topRight,
          builder: (context, overlay) {
            return SurfaceCard(
              fillColor: Colors.yellow[600],
              filled: true,
              child: Basic(
                leading: const Icon(
                  SpotubeIcons.error,
                  color: Colors.black,
                ),
                title: Text(
                  context.l10n.connect_client_alert(clientOrigin),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        );
      })
    ];

    return () {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    };
  }, []);
}
