import 'package:flutter/material.dart' hide Image;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/shimmers/shimmer_playbutton_card.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/playlist/playlist_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/authentication_provider.dart';
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
    final auth = ref.watch(AuthenticationNotifier.provider);

    final playlistsQuery = useQueries.playlist.ofMine(ref);

    final likedTracksPlaylist = useMemoized(
        () => PlaylistSimple()
          ..name = "Liked Tracks"
          ..description = "All your liked tracks"
          ..type = "playlist"
          ..collaborative = false
          ..public = false
          ..id = "user-liked-tracks"
          ..images = [
            Image()
              ..height = 300
              ..width = 300
              ..url =
                  "https://t.scdn.co/images/3099b3803ad9496896c43f22fe9be8c4.png"
          ],
        []);

    final playlists = useMemoized(
      () {
        if (searchText.value.isEmpty) {
          return [
            likedTracksPlaylist,
            ...?playlistsQuery.data,
          ];
        }
        return [
          likedTracksPlaylist,
          ...?playlistsQuery.data,
        ]
            .map((e) => Tuple2(
                  weightedRatio(e.name!, searchText.value),
                  e,
                ))
            .sorted((a, b) => b.item1.compareTo(a.item1))
            .where((e) => e.item1 > 50)
            .map((e) => e.item2)
            .toList();
      },
      [playlistsQuery.data, searchText.value],
    );

    if (auth == null) {
      return const AnonymousFallback();
    }

    return RefreshIndicator(
      onRefresh: playlistsQuery.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              TextField(
                onChanged: (value) => searchText.value = value,
                decoration: const InputDecoration(
                  hintText: "Filter your playlists...",
                  prefixIcon: Icon(SpotubeIcons.filter),
                ),
              ),
              const SizedBox(height: 20),
              if (playlistsQuery.isLoading || !playlistsQuery.hasData)
                const Center(child: ShimmerPlaybuttonCard(count: 7))
              else
                Wrap(
                  runSpacing: 10,
                  children: playlists
                      .map((playlist) => PlaylistCard(playlist))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
