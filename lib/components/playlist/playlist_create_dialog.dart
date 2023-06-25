import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify_provider.dart';

class PlaylistCreateDialog extends HookConsumerWidget {
  /// Track ids to add to the playlist
  final List<String> trackIds;
  const PlaylistCreateDialog({
    Key? key,
    this.trackIds = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);
    final playlistName = useTextEditingController();
    final description = useTextEditingController();
    final public = useState(false);
    final collaborative = useState(false);
    final client = useQueryClient();
    final navigator = Navigator.of(context);

    Future<void> onCreate() async {
      if (playlistName.text.isEmpty) return;
      final me = await spotify.me.get();
      final playlist = await spotify.playlists.createPlaylist(
        me.id!,
        playlistName.text,
        collaborative: collaborative.value,
        public: public.value,
        description: description.text,
      );
      if (trackIds.isNotEmpty) {
        await spotify.playlists.addTracks(
          trackIds.map((id) => "spotify:track:$id").toList(),
          playlist.id!,
        );
      }
      await client
          .getQuery(
            "current-user-playlists",
          )
          ?.refresh();
      navigator.pop(playlist);
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
  }
}

class PlaylistCreateDialogButton extends HookConsumerWidget {
  const PlaylistCreateDialogButton({Key? key}) : super(key: key);

  showPlaylistDialog(BuildContext context, SpotifyApi spotify) {
    showDialog(
      context: context,
      builder: (context) => const PlaylistCreateDialog(),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);
    final spotify = ref.watch(spotifyProvider);

    if (mediaQuery.smAndDown) {
      return ElevatedButton(
        style: FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: const Icon(SpotubeIcons.addFilled),
        onPressed: () => showPlaylistDialog(context, spotify),
      );
    }

    return FilledButton.tonalIcon(
        style: FilledButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
        icon: const Icon(SpotubeIcons.addFilled),
        label: Text(context.l10n.create_playlist),
        onPressed: () => showPlaylistDialog(context, spotify));
  }
}
