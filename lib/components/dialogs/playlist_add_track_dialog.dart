import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/models/metadata/metadata.dart';

import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/metadata_plugin/library/playlists.dart';
import 'package:spotube/provider/metadata_plugin/core/user.dart';

class PlaylistAddTrackDialog extends HookConsumerWidget {
  /// The id of the playlist this dialog was opened from
  final String? openFromPlaylist;
  final List<SpotubeTrackObject> tracks;
  const PlaylistAddTrackDialog({
    required this.tracks,
    required this.openFromPlaylist,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final typography = Theme.of(context).typography;
    final userPlaylists = ref.watch(metadataPluginSavedPlaylistsProvider);
    final favoritePlaylistsNotifier =
        ref.watch(metadataPluginSavedPlaylistsProvider.notifier);

    final me = ref.watch(metadataPluginUserProvider);

    final filteredPlaylists = useMemoized(
      () =>
          userPlaylists.asData?.value.items
              .where(
                (playlist) =>
                    playlist.owner.id == me.asData?.value?.id &&
                    playlist.id != openFromPlaylist,
              )
              .toList() ??
          [],
      [userPlaylists.asData?.value, me.asData?.value?.id, openFromPlaylist],
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
            tracks.map((e) => e.id).toList(),
          ),
        ),
      ).then((_) => context.mounted ? Navigator.pop(context, true) : null);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.add_to_playlist,
              style: typography.large,
            ),
            const Spacer(),
            const PlaylistCreateDialogButton(),
          ],
        ),
        actions: [
          OutlineButton(
            child: Text(context.l10n.cancel),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          PrimaryButton(
            onPressed: onAdd,
            child: Text(context.l10n.add),
          ),
        ],
        content: SizedBox(
          height: 300,
          child: userPlaylists.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredPlaylists.length,
                  itemBuilder: (context, index) {
                    final playlist = filteredPlaylists.elementAt(index);
                    return Button.ghost(
                      style: ButtonVariance.ghost.copyWith(
                        padding: (context, _, __) {
                          return const EdgeInsets.symmetric(vertical: 8);
                        },
                      ),
                      leading: Avatar(
                        initials: Avatar.getInitials(playlist.name),
                        provider: UniversalImage.imageProvider(
                          playlist.images.asUrlString(
                            placeholder: ImagePlaceholder.collection,
                          ),
                        ),
                      ),
                      trailing: Checkbox(
                        state: (playlistsCheck.value[playlist.id] ?? false)
                            ? CheckboxState.checked
                            : CheckboxState.unchecked,
                        onChanged: (val) {
                          playlistsCheck.value = {
                            ...playlistsCheck.value,
                            playlist.id: val == CheckboxState.checked,
                          };
                        },
                      ),
                      onPressed: () {
                        playlistsCheck.value = {
                          ...playlistsCheck.value,
                          playlist.id:
                              !(playlistsCheck.value[playlist.id] ?? false),
                        };
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(playlist.name),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
