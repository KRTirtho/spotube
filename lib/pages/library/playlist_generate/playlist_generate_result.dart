import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/library/playlist_generate/simple_track_tile.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/spotify/recommendation_seeds.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class PlaylistGenerateResultPage extends HookConsumerWidget {
  static const name = "playlist_generate_result";

  final GeneratePlaylistProviderInput state;

  const PlaylistGenerateResultPage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context, ref) {
    final router = GoRouter.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);

    final generatedPlaylist = ref.watch(generatePlaylistProvider(state));

    final selectedTracks = useState<List<String>>(
      generatedPlaylist.asData?.value.map((e) => e.id!).toList() ?? [],
    );

    useEffect(() {
      if (generatedPlaylist.asData?.value != null) {
        selectedTracks.value =
            generatedPlaylist.asData!.value.map((e) => e.id!).toList();
      }
      return null;
    }, [generatedPlaylist.asData?.value]);

    final isAllTrackSelected = selectedTracks.value.length ==
        (generatedPlaylist.asData?.value.length ?? 0);

    return Scaffold(
      appBar: const PageWindowTitleBar(leading: BackButton()),
      body: generatedPlaylist.isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Text(context.l10n.generating_playlist),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      mainAxisExtent: 32,
                    ),
                    shrinkWrap: true,
                    children: [
                      FilledButton.tonalIcon(
                        icon: const Icon(SpotubeIcons.play),
                        label: Text(context.l10n.play),
                        onPressed: selectedTracks.value.isEmpty
                            ? null
                            : () async {
                                await playlistNotifier.load(
                                  generatedPlaylist.asData!.value
                                      .where(
                                        (e) => selectedTracks.value
                                            .contains(e.id!),
                                      )
                                      .toList(),
                                  autoPlay: true,
                                );
                              },
                      ),
                      FilledButton.tonalIcon(
                        icon: const Icon(SpotubeIcons.queueAdd),
                        label: Text(context.l10n.add_to_queue),
                        onPressed: selectedTracks.value.isEmpty
                            ? null
                            : () async {
                                await playlistNotifier.addTracks(
                                  generatedPlaylist.asData!.value.where(
                                    (e) => selectedTracks.value.contains(e.id!),
                                  ),
                                );
                                if (context.mounted) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.l10n.add_count_to_queue(
                                          selectedTracks.value.length,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                      ),
                      FilledButton.tonalIcon(
                        icon: const Icon(SpotubeIcons.addFilled),
                        label: Text(context.l10n.create_a_playlist),
                        onPressed: selectedTracks.value.isEmpty
                            ? null
                            : () async {
                                final playlist = await showDialog<Playlist>(
                                  context: context,
                                  builder: (context) => PlaylistCreateDialog(
                                    trackIds: selectedTracks.value,
                                  ),
                                );

                                if (playlist != null) {
                                  router.goNamed(
                                    PlaylistPage.name,
                                    pathParameters: {
                                      "id": playlist.id!,
                                    },
                                    extra: playlist,
                                  );
                                }
                              },
                      ),
                      FilledButton.tonalIcon(
                        icon: const Icon(SpotubeIcons.playlistAdd),
                        label: Text(context.l10n.add_to_playlist),
                        onPressed: selectedTracks.value.isEmpty
                            ? null
                            : () async {
                                final hasAdded = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => PlaylistAddTrackDialog(
                                    openFromPlaylist: null,
                                    tracks: selectedTracks.value
                                        .map(
                                          (e) => generatedPlaylist.asData!.value
                                              .firstWhere(
                                            (element) => element.id == e,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );

                                if (context.mounted && hasAdded == true) {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.l10n.add_count_to_playlist(
                                          selectedTracks.value.length,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (generatedPlaylist.asData?.value != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.selected_count_tracks(
                            selectedTracks.value.length,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isAllTrackSelected) {
                              selectedTracks.value = [];
                            } else {
                              selectedTracks.value = generatedPlaylist
                                      .asData?.value
                                      .map((e) => e.id!)
                                      .toList() ??
                                  [];
                            }
                          },
                          icon: const Icon(SpotubeIcons.selectionCheck),
                          label: Text(
                            isAllTrackSelected
                                ? context.l10n.deselect_all
                                : context.l10n.select_all,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Card(
                    margin: const EdgeInsets.all(0),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final track
                              in generatedPlaylist.asData?.value ?? [])
                            CheckboxListTile(
                              value: selectedTracks.value.contains(track.id),
                              onChanged: (value) {
                                if (value == true) {
                                  selectedTracks.value.add(track.id!);
                                } else {
                                  selectedTracks.value.remove(track.id);
                                }
                                selectedTracks.value =
                                    selectedTracks.value.toList();
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              title: SimpleTrackTile(track: track),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
