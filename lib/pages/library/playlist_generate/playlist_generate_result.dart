import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/modules/library/playlist_generate/simple_track_tile.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/spotify/recommendation_seeds.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';

@RoutePage()
class PlaylistGenerateResultPage extends HookConsumerWidget {
  static const name = "playlist_generate_result";

  final GeneratePlaylistProviderInput state;

  const PlaylistGenerateResultPage({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context, ref) {
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

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: const [
          TitleBar(leading: [BackButton()])
        ],
        child: generatedPlaylist.isLoading
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
                        Button.primary(
                          leading: const Icon(SpotubeIcons.play),
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
                          child: Text(context.l10n.play),
                        ),
                        Button.primary(
                          leading: const Icon(SpotubeIcons.queueAdd),
                          onPressed: selectedTracks.value.isEmpty
                              ? null
                              : () async {
                                  await playlistNotifier.addTracks(
                                    generatedPlaylist.asData!.value.where(
                                      (e) =>
                                          selectedTracks.value.contains(e.id!),
                                    ),
                                  );
                                  if (context.mounted) {
                                    showToast(
                                      context: context,
                                      location: ToastLocation.topRight,
                                      builder: (context, overlay) {
                                        return SurfaceCard(
                                          child: Text(
                                            context.l10n.add_count_to_queue(
                                              selectedTracks.value.length,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                          child: Text(context.l10n.add_to_queue),
                        ),
                        Button.primary(
                          leading: const Icon(SpotubeIcons.addFilled),
                          onPressed: selectedTracks.value.isEmpty
                              ? null
                              : () async {
                                  final playlist = await showDialog<Playlist>(
                                    context: context,
                                    builder: (context) => PlaylistCreateDialog(
                                      trackIds: selectedTracks.value,
                                    ),
                                  );

                                  if (playlist != null && context.mounted) {
                                    context.navigateTo(
                                      PlaylistRoute(
                                        id: playlist.id!,
                                        playlist: playlist,
                                      ),
                                    );
                                  }
                                },
                          child: Text(context.l10n.create_a_playlist),
                        ),
                        Button.primary(
                          leading: const Icon(SpotubeIcons.playlistAdd),
                          onPressed: selectedTracks.value.isEmpty
                              ? null
                              : () async {
                                  final hasAdded = await showDialog<bool>(
                                    context: context,
                                    builder: (context) =>
                                        PlaylistAddTrackDialog(
                                      openFromPlaylist: null,
                                      tracks: selectedTracks.value
                                          .map(
                                            (e) => generatedPlaylist
                                                .asData!.value
                                                .firstWhere(
                                              (element) => element.id == e,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  );

                                  if (context.mounted && hasAdded == true) {
                                    showToast(
                                      context: context,
                                      location: ToastLocation.topRight,
                                      builder: (context, overlay) {
                                        return SurfaceCard(
                                          child: Text(
                                            context.l10n.add_count_to_playlist(
                                              selectedTracks.value.length,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                          child: Text(context.l10n.add_to_playlist),
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
                          Button.secondary(
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
                            leading: const Icon(SpotubeIcons.selectionCheck),
                            child: Text(
                              isAllTrackSelected
                                  ? context.l10n.deselect_all
                                  : context.l10n.select_all,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final track
                              in generatedPlaylist.asData?.value ?? [])
                            Row(
                              spacing: 5,
                              children: [
                                Checkbox(
                                  state: selectedTracks.value.contains(track.id)
                                      ? CheckboxState.checked
                                      : CheckboxState.unchecked,
                                  onChanged: (value) {
                                    if (value == CheckboxState.checked) {
                                      selectedTracks.value.add(track.id!);
                                    } else {
                                      selectedTracks.value.remove(track.id);
                                    }
                                    selectedTracks.value =
                                        selectedTracks.value.toList();
                                  },
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedTracks.value.contains(track.id)
                                          ? selectedTracks.value
                                              .remove(track.id)
                                          : selectedTracks.value.add(track.id!);
                                      selectedTracks.value =
                                          selectedTracks.value.toList();
                                    },
                                    child: SimpleTrackTile(track: track),
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
