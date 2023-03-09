import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';

class PlaylistAddTrackDialog extends HookConsumerWidget {
  final List<Track> tracks;
  const PlaylistAddTrackDialog({
    required this.tracks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final userPlaylists = useQueries.playlist.ofMine(ref);
    final me = useQueries.user.me(ref);
    final filteredPlaylists = userPlaylists.data?.where(
      (playlist) =>
          playlist.owner?.id != null && playlist.owner!.id == me.data?.id,
    );
    final playlistsCheck = useState(<String, bool>{});

    Future<void> onAdd() async {
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
    }

    return AlertDialog(
      title: const Text("Add to Playlist"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FilledButton(
          onPressed: onAdd,
          child: const Text("Add"),
        ),
      ],
      content: SizedBox(
        height: 300,
        width: 300,
        child: !userPlaylists.hasData
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredPlaylists!.length,
                itemBuilder: (context, index) {
                  final playlist = filteredPlaylists.elementAt(index);
                  return CheckboxListTile(
                    title: Text(playlist.name!),
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
