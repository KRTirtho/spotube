import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlaylistAddTrackDialog extends HookConsumerWidget {
  /// The id of the playlist this dialog was opened from
  final String? openFromPlaylist;
  final List<Track> tracks;
  const PlaylistAddTrackDialog({
    required this.tracks,
    required this.openFromPlaylist,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);
    final spotify = ref.watch(spotifyProvider);
    final userPlaylists = useQueries.playlist.ofMineAll(ref);

    final me = useQueries.user.me(ref);

    final filteredPlaylists = useMemoized(
      () =>
          userPlaylists.data
              ?.where(
                (playlist) =>
                    playlist.owner?.id != null &&
                    playlist.owner!.id == me.data?.id &&
                    playlist.id != openFromPlaylist,
              )
              .toList() ??
          [],
      [userPlaylists.data, me.data?.id, openFromPlaylist],
    );

    final playlistsCheck = useState(<String, bool>{});
    final queryClient = useQueryClient();

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
      ).then((_) => Navigator.pop(context, true));

      await queryClient.refreshQueries(
        selectedPlaylists
            .map((playlistId) => "playlist-tracks/$playlistId")
            .toList(),
      );
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
                        TypeConversionUtils.image_X_UrlString(
                          playlist.images,
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
