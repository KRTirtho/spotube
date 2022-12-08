import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/components/playlist/playlist_create_dialog.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';

class UserPlaylists extends HookConsumerWidget {
  const UserPlaylists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }

    final playlistsQuery = useQuery(
      job: Queries.playlist.ofMine,
      externalData: ref.watch(spotifyProvider),
    );
    Image image = Image();
    image.height = 300;
    image.width = 300;
    PlaylistSimple likedTracksPlaylist = PlaylistSimple();
    likedTracksPlaylist.name = "Liked Tracks";
    likedTracksPlaylist.type = "playlist";
    likedTracksPlaylist.collaborative = false;
    likedTracksPlaylist.public = false;
    likedTracksPlaylist.id = "user-liked-tracks";
    image.url = "https://t.scdn.co/images/3099b3803ad9496896c43f22fe9be8c4.png";
    likedTracksPlaylist.images = [image];

    if (playlistsQuery.isLoading || !playlistsQuery.hasData) {
      return const Center(child: ShimmerPlaybuttonCard(count: 7));
    }

    return SingleChildScrollView(
      child: Material(
        type: MaterialType.transparency,
        textStyle: PlatformTheme.of(context).textTheme!.body!,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 20, // gap between adjacent chips
            runSpacing: 20, // gap between lines
            alignment: WrapAlignment.center,
            children: [
              const PlaylistCreateDialog(),
              PlaylistCard(likedTracksPlaylist),
              ...playlistsQuery.data!
                  .map((playlist) => PlaylistCard(playlist))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
