import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:tuple/tuple.dart';

class UserPlaylists extends HookConsumerWidget {
  const UserPlaylists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final searchText = useState('');
    final breakpoint = useBreakpoints();
    final spacing = useBreakpointValue<double>(
      sm: 0,
      others: 20,
    );
    final viewType = MediaQuery.of(context).size.width < 480
        ? PlaybuttonCardViewType.list
        : PlaybuttonCardViewType.square;
    final auth = ref.watch(authProvider);

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

    final playlists = useMemoized(
      () => [
        likedTracksPlaylist,
        ...?playlistsQuery.data,
      ]
          .map((e) => Tuple2(
                searchText.value.isEmpty
                    ? 100
                    : weightedRatio(e.name!, searchText.value),
                e,
              ))
          .sorted((a, b) => b.item1.compareTo(a.item1))
          .where((e) => e.item1 > 50)
          .map((e) => e.item2)
          .toList(),
      [playlistsQuery.data, searchText.value],
    );

    if (auth.isAnonymous) {
      return const AnonymousFallback();
    }
    if (playlistsQuery.isLoading || !playlistsQuery.hasData) {
      return const Center(child: ShimmerPlaybuttonCard(count: 7));
    }

    final children = [
      const PlaylistCreateDialog(),
      ...playlists
          .map((playlist) => PlaylistCard(
                playlist,
                viewType: viewType,
              ))
          .toList(),
    ];
    return SingleChildScrollView(
      child: Material(
        type: MaterialType.transparency,
        textStyle: PlatformTheme.of(context).textTheme!.body!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PlatformTextField(
                onChanged: (value) => searchText.value = value,
                placeholder: "Search your playlists...",
                prefixIcon: Icons.search,
              ),
              const SizedBox(height: 20),
              Center(
                child: Wrap(
                  spacing: spacing, // gap between adjacent chips
                  runSpacing: 20, // gap between lines
                  alignment: breakpoint.isSm
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
