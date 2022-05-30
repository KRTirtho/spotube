import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class PlaylistCreateDialog extends HookConsumerWidget {
  const PlaylistCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    return TextButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_box_rounded, size: 50),
          Text("Create Playlist", style: TextStyle(fontSize: 22)),
        ],
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return HookBuilder(builder: (context) {
              final playlistName = useTextEditingController();
              final description = useTextEditingController();
              final public = useState(false);
              final collaborative = useState(false);

              return AlertDialog(
                title: const Text("Create a Playlist"),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: const Text("Create"),
                    onPressed: () async {
                      if (playlistName.text.isEmpty) return;
                      final me = await spotify.me.get();
                      await spotify.playlists
                          .createPlaylist(
                        me.id!,
                        playlistName.text,
                        collaborative: collaborative.value,
                        public: public.value,
                        description: description.text,
                      )
                          .then((_) {
                        ref.refresh(currentUserPlaylistsQuery);
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: playlistName,
                        decoration: const InputDecoration(
                          hintText: "Name of the playlist",
                          label: Text("Playlist Name"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "Description...",
                        ),
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        value: public.value,
                        title: const Text("Public"),
                        onChanged: (val) => public.value = val ?? false,
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        value: collaborative.value,
                        title: const Text("Collaborative"),
                        onChanged: (val) => collaborative.value = val ?? false,
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15, vertical: 100)),
      ),
    );
  }
}
