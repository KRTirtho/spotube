import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify_provider.dart';

class PlaylistCreateDialog extends HookConsumerWidget {
  const PlaylistCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      icon: const Icon(SpotubeIcons.addFilled),
      label: Text(context.l10n.create_playlist),
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
                title: Text(context.l10n.create_a_playlist),
                actions: [
                  OutlinedButton(
                    child: Text(context.l10n.cancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FilledButton(
                    onPressed: onCreate,
                    child: Text(context.l10n.create),
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
                        decoration: InputDecoration(
                          hintText: context.l10n.name_of_playlist,
                          labelText: context.l10n.name_of_playlist,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: description,
                        decoration: InputDecoration(
                          hintText: context.l10n.description,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        title: Text(context.l10n.public),
                        value: public.value,
                        onChanged: (val) => public.value = val ?? false,
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        title: Text(context.l10n.collaborative),
                        value: collaborative.value,
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
    );
  }
}
