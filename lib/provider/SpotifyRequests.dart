import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/timed-lyrics.dart';
import 'package:spotube/models/SpotubeTrack.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:collection/collection.dart';

final categoriesQuery = FutureProvider.family<Page<Category>, int>(
  (ref, pageKey) {
    final spotify = ref.watch(spotifyProvider);
    final recommendationMarket = ref.watch(
      userPreferencesProvider.select((s) => s.recommendationMarket),
    );
    return spotify.categories
        .list(country: recommendationMarket)
        .getPage(15, pageKey);
  },
);

final categoryPlaylistsQuery =
    FutureProvider.family<Page<PlaylistSimple>, String>(
  (ref, value) {
    final spotify = ref.watch(spotifyProvider);
    final List data = value.split("/");
    final id = data.first;
    final pageKey = data.last;
    return (id != "user-featured-playlists"
            ? spotify.playlists.getByCategoryId(id)
            : spotify.playlists.featured)
        .getPage(3, int.parse(pageKey));
  },
);

final currentUserPlaylistsQuery = FutureProvider<Iterable<PlaylistSimple>>(
  (ref) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists.me.all();
  },
);

final currentUserAlbumsQuery = FutureProvider<Iterable<AlbumSimple>>(
  (ref) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.savedAlbums().all();
  },
);

final currentUserFollowingArtistsQuery =
    FutureProvider.family<CursorPage<Artist>, String>(
  (ref, pageKey) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.me.following(FollowingType.artist).getPage(15, pageKey);
  },
);

final artistProfileQuery = FutureProvider.family<Artist, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.get(id);
  },
);

final currentUserFollowsArtistQuery = FutureProvider.family<bool, String>(
  (ref, artistId) async {
    final spotify = ref.watch(spotifyProvider);
    final result = await spotify.me.isFollowing(
      FollowingType.artist,
      [artistId],
    );
    return result.first;
  },
);

final artistTopTracksQuery =
    FutureProvider.family<Iterable<Track>, String>((ref, id) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.artists.getTopTracks(id, "US");
});

final artistAlbumsQuery = FutureProvider.family<Page<Album>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.albums(id).getPage(5, 0);
  },
);

final artistRelatedArtistsQuery =
    FutureProvider.family<Iterable<Artist>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.artists.getRelatedArtists(id);
  },
);

final currentUserSavedTracksQuery = FutureProvider<List<Track>>((ref) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.tracks.me.saved.all().then(
        (tracks) => tracks.map((e) => e.track!).toList(),
      );
});

final playlistTracksQuery = FutureProvider.family<List<Track>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return id != "user-liked-tracks"
        ? spotify.playlists.getTracksByPlaylistId(id).all().then(
              (value) => value.toList(),
            )
        : spotify.tracks.me.saved.all().then(
              (tracks) => tracks.map((e) => e.track!).toList(),
            );
  },
);

final albumTracksQuery = FutureProvider.family<List<TrackSimple>, String>(
  (ref, id) {
    final spotify = ref.watch(spotifyProvider);
    return spotify.albums.getTracks(id).all().then((value) => value.toList());
  },
);

final currentUserQuery = FutureProvider<User>(
  (ref) async {
    final spotify = ref.watch(spotifyProvider);
    final me = await spotify.me.get();
    if (me.images == null || me.images?.isEmpty == true) {
      me.images = [
        Image()
          ..height = 50
          ..width = 50
          ..url = imageToUrlString(me.images),
      ];
    }
    return me;
  },
);

final playlistIsFollowedQuery = FutureProvider.family<bool, String>(
  (ref, raw) {
    final data = jsonDecode(raw);
    final playlistId = data["playlistId"] as String;
    final userId = data["userId"] as String;
    final spotify = ref.watch(spotifyProvider);
    return spotify.playlists
        .followedBy(playlistId, [userId]).then((value) => value.first);
  },
);

final albumIsSavedForCurrentUserQuery =
    FutureProvider.family<bool, String>((ref, albumId) {
  final spotify = ref.watch(spotifyProvider);
  return spotify.me.isSavedAlbums([albumId]).then((value) => value.first);
});

final searchQuery = FutureProvider.family<List<Page>, String>((ref, term) {
  final spotify = ref.watch(spotifyProvider);
  if (term.isEmpty) return [];
  return spotify.search.get(term).first(10);
});

final geniusLyricsQuery = FutureProvider<String?>(
  (ref) {
    final currentTrack = ref.watch(playbackProvider.select((s) => s.track));
    final geniusAccessToken =
        ref.watch(userPreferencesProvider.select((s) => s.geniusAccessToken));
    if (currentTrack == null) {
      return "“Give this player a track to play”\n- S'Challa";
    }
    return getLyrics(
      currentTrack.name!,
      currentTrack.artists?.map((s) => s.name).whereNotNull().toList() ?? [],
      apiKey: geniusAccessToken,
      optimizeQuery: true,
    );
  },
);

final rentanadviserLyricsQuery = FutureProvider<SubtitleSimple?>(
  (ref) {
    final currentTrack = ref.watch(playbackProvider.select((s) => s.track));
    if (currentTrack == null) return null;
    return getTimedLyrics(currentTrack as SpotubeTrack);
  },
);
