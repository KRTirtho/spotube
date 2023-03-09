import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/provider/spotify_provider.dart';

class PlaylistCreateDialog extends HookConsumerWidget {
  const PlaylistCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return HookBuilder(builder: (context) {
                final playlistName = useTextEditingController();
                final description = useTextEditingController();
                final public = useState(false);
                final collaborative = useState(false);
                final client = useQueryClient();
                final navigator = Navigator.of(context);

                onCreate() async {
                  if (playlistName.text.isEmpty) return;
                  final me = await spotify.me.get();
                  await spotify.playlists.createPlaylist(
                    me.id!,
                    playlistName.text,
                    collaborative: collaborative.value,
                    public: public.value,
                    description: description.text,
                  );
                  await client
                      .getQuery(
                        "current-user-playlists",
                      )
                      ?.refresh();
                  navigator.pop();
                }

                return AlertDialog(
                  title: const Text("Create a Playlist"),
                  actions: [
                    OutlinedButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FilledButton(
                      onPressed: onCreate,
                      child: const Text("Create"),
                    ),
                  ],
                  content: Container(
                    width: MediaQuery.of(context).size.width,
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextField(
                          controller: playlistName,
                          decoration: const InputDecoration(
                            hintText: "Name of the playlist",
                            labelText: "Playlist Name",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: description,
                          decoration: const InputDecoration(
                            hintText: "Description...",
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                          title: const Text("Public"),
                          value: public.value,
                          onChanged: (val) => public.value = val ?? false,
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                          title: const Text("Collaborative"),
                          value: collaborative.value,
                          onChanged: (val) =>
                              collaborative.value = val ?? false,
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
            const EdgeInsets.symmetric(vertical: 100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(SpotubeIcons.addFilled, size: 40),
            Text("Create Playlist", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
