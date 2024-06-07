import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class PlaylistAddTrackDialog extends HookConsumerWidget {
  /// The id of the playlist this dialog was opened from
  final String? openFromPlaylist;
  final List<Track> tracks;
  const PlaylistAddTrackDialog({
    required this.tracks,
    required this.openFromPlaylist,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);
    final userPlaylists = ref.watch(favoritePlaylistsProvider);
    final favoritePlaylistsNotifier =
        ref.watch(favoritePlaylistsProvider.notifier);

    final me = ref.watch(meProvider);

    final filteredPlaylists = useMemoized(
      () =>
          userPlaylists.asData?.value.items
              .where(
                (playlist) =>
                    playlist.owner?.id != null &&
                    playlist.owner!.id == me.asData?.value.id &&
                    playlist.id != openFromPlaylist,
              )
              .toList() ??
          [],
      [userPlaylists.asData?.value, me.asData?.value.id, openFromPlaylist],
    );

    final playlistsCheck = useState(<String, bool>{});

    useEffect(() {
      if (userPlaylists.asData?.value != null) {
        favoritePlaylistsNotifier.fetchAll();
      }
      return null;
    }, [userPlaylists.asData?.value]);

    Future<void> onAdd() async {
      final selectedPlaylists = playlistsCheck.value.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key);

      await Future.wait(
        selectedPlaylists.map(
          (playlistId) => favoritePlaylistsNotifier.addTracks(
            playlistId,
            tracks.map((e) => e.id!).toList(),
          ),
        ),
      ).then((_) => Navigator.pop(context, true));
    }

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            context.l10n.add_to_playlist,
            style: textTheme.titleMedium,
          ),
          const Gap(20),
          const PlaylistCreateDialogButton(),
        ],
      ),
      actions: [
        OutlinedButton(
          child: Text(context.l10n.cancel),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FilledButton(
          onPressed: onAdd,
          child: Text(context.l10n.add),
        ),
      ],
      content: SizedBox(
        height: 300,
        width: 300,
        child: userPlaylists.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filteredPlaylists.length,
                itemBuilder: (context, index) {
                  final playlist = filteredPlaylists.elementAt(index);
                  return CheckboxListTile(
                    secondary: CircleAvatar(
                      backgroundImage: UniversalImage.imageProvider(
                        playlist.images.asUrlString(
                          placeholder: ImagePlaceholder.collection,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(playlist.name!),
                    ),
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
