import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class PlaylistCreateDialog extends HookConsumerWidget {
  const PlaylistCreateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final spotify = ref.watch(spotifyProvider);

    return PlatformTextButton(
      onPressed: () {
        showPlatformAlertDialog(
          context,
          builder: (context) {
            return HookBuilder(builder: (context) {
              final playlistName = useTextEditingController();
              final description = useTextEditingController();
              final public = useState(false);
              final collaborative = useState(false);

              return PlatformAlertDialog(
                macosAppIcon: Sidebar.brandLogo(),
                title: const Text("Create a Playlist"),
                primaryActions: [
                  PlatformFilledButton(
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
                        QueryBowl.of(context).refetchQueries([
                          currentUserPlaylistsQueryJob.queryKey,
                        ]);
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
                secondaryActions: [
                  PlatformFilledButton(
                    isSecondary: true,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                ],
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      PlatformTextField(
                        controller: playlistName,
                        placeholder: "Name of the playlist",
                        label: "Playlist Name",
                      ),
                      const SizedBox(height: 10),
                      PlatformTextField(
                        controller: description,
                        placeholder: "Description...",
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 10),
                      PlatformCheckbox(
                        value: public.value,
                        label: const PlatformText("Public"),
                        onChanged: (val) => public.value = val ?? false,
                      ),
                      const SizedBox(height: 10),
                      PlatformCheckbox(
                        value: collaborative.value,
                        label: const PlatformText("Collaborative"),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_box_rounded, size: 50),
          Text("Create Playlist", style: TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
