import 'package:collection/collection.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/components/dialogs/prompt_dialog.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/metadata_plugin/search/all.dart';

class SearchTracksSection extends HookConsumerWidget {
  const SearchTracksSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final searchTerm = ref.watch(searchTermStateProvider);
    final search = ref.watch(metadataPluginSearchAllProvider(searchTerm));
    final tracks = search.asData?.value.tracks ?? [];
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final playlist = ref.watch(audioPlayerProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tracks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              context.l10n.songs,
              style: theme.typography.h4,
            ),
          ),
        if (search.isLoading)
          const CircularProgressIndicator()
        else
          ...tracks.mapIndexed((i, track) {
            return TrackTile(
              index: i,
              track: track,
              playlist: playlist,
              onTap: () async {
                final isRemoteDevice =
                    await showSelectDeviceDialog(context, ref);

                if (isRemoteDevice == null) return;

                if (isRemoteDevice) {
                  final remotePlayback = ref.read(connectProvider.notifier);
                  final remotePlaylist = ref.read(queueProvider);

                  final isTrackPlaying =
                      remotePlaylist.activeTrack?.id == track.id;

                  if (!isTrackPlaying && context.mounted) {
                    final shouldPlay = (playlist.tracks.length) > 20
                        ? await showPromptDialog(
                            context: context,
                            title: context.l10n.playing_track(
                              track.name,
                            ),
                            message: context.l10n.queue_clear_alert(
                              playlist.tracks.length,
                            ),
                          )
                        : true;

                    if (shouldPlay) {
                      await remotePlayback.load(
                        WebSocketLoadEventData.playlist(
                          tracks: [track],
                        ),
                      );
                    }
                  }
                } else {
                  final isTrackPlaying = playlist.activeTrack?.id == track.id;
                  if (!isTrackPlaying && context.mounted) {
                    final shouldPlay = (playlist.tracks.length) > 20
                        ? await showPromptDialog(
                            context: context,
                            title: context.l10n.playing_track(
                              track.name,
                            ),
                            message: context.l10n.queue_clear_alert(
                              playlist.tracks.length,
                            ),
                          )
                        : true;

                    if (shouldPlay) {
                      await playlistNotifier.load(
                        [track],
                        autoPlay: true,
                      );
                    }
                  }
                }
              },
            );
          }),
      ],
    );
  }
}
