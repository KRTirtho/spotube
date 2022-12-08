import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class PlaylistAddTrackDialog extends HookConsumerWidget {
  final List<Track> tracks;
  const PlaylistAddTrackDialog({
    required this.tracks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final userPlaylists = useQuery(
      job: currentUserPlaylistsQueryJob,
      externalData: spotify,
    );
    final me = useQuery(
      job: currentUserQueryJob,
      externalData: spotify,
    );
    final filteredPlaylists = userPlaylists.data?.where(
      (playlist) =>
          playlist.owner?.id != null && playlist.owner!.id == me.data?.id,
    );
    final playlistsCheck = useState(<String, bool>{});

    return PlatformAlertDialog(
      title: const PlatformText("Add to Playlist"),
      secondaryActions: [
        PlatformFilledButton(
          isSecondary: true,
          child: const PlatformText("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      primaryActions: [
        PlatformFilledButton(
          child: const PlatformText("Add"),
          onPressed: () async {
            final selectedPlaylists = playlistsCheck.value.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key);

            await Future.wait(
              selectedPlaylists.map(
                (playlistId) => spotify.playlists.addTracks(
                    tracks
                        .map(
                          (track) => track.uri!,
                        )
                        .toList(),
                    playlistId),
              ),
            ).then((_) => Navigator.pop(context));
          },
        )
      ],
      content: SizedBox(
        height: 300,
        width: 300,
        child: !userPlaylists.hasData
            ? const Center(child: PlatformCircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredPlaylists!.length,
                itemBuilder: (context, index) {
                  final playlist = filteredPlaylists.elementAt(index);
                  return PlatformCheckbox(
                    label: PlatformText(playlist.name!),
                    value: playlistsCheck.value[playlist.id] ?? false,
                    onChanged: (val) {
                      playlistsCheck.value = {
                        ...playlistsCheck.value,
                        playlist.id!: val == true
                      };
                    },
                  );
                },
              ),
      ),
    );
  }
}
