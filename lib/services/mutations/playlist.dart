import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_mutation.dart';
import 'package:spotube/services/queries/queries.dart';

typedef PlaylistCRUDVariables = ({
  String playlistName,
  bool? public,
  bool? collaborative,
  String? description,
  String? base64Image,
});

class PlaylistMutations {
  const PlaylistMutations();

  Mutation<bool, dynamic, bool> toggleFavorite(
    WidgetRef ref,
    String playlistId, {
    List<String>? refreshQueries,
    List<String>? refreshInfiniteQueries,
    ValueChanged<bool>? onData,
  }) {
    return useSpotifyMutation<bool, dynamic, bool, dynamic>(
      "toggle-playlist-like/$playlistId",
      (isLiked, spotify) async {
        if (isLiked) {
          await spotify.playlists.unfollowPlaylist(playlistId);
        } else {
          await spotify.playlists.followPlaylist(playlistId);
        }
        return !isLiked;
      },
      ref: ref,
      refreshQueries: refreshQueries,
      refreshInfiniteQueries: [
        ...?refreshInfiniteQueries,
        "current-user-playlists",
      ],
      onData: (data, recoveryData) {
        onData?.call(data);
      },
    );
  }

  Mutation<bool, dynamic, String> removeTrackOf(
    WidgetRef ref,
    String playlistId,
  ) {
    return useSpotifyMutation<bool, dynamic, String, dynamic>(
      "remove-track-from-playlist/$playlistId",
      (trackId, spotify) async {
        await spotify.playlists.removeTracks([trackId], playlistId);
        return true;
      },
      ref: ref,
      refreshQueries: ["playlist-tracks/$playlistId"],
    );
  }

  Mutation<Playlist, dynamic, PlaylistCRUDVariables> create(
    WidgetRef ref, {
    List<String>? trackIds,
    ValueChanged<dynamic>? onError,
    ValueChanged<Playlist>? onData,
  }) {
    final me = useQueries.user.me(ref);
    return useSpotifyMutation<Playlist, dynamic, PlaylistCRUDVariables, void>(
      "create-playlist",
      (variable, spotify) async {
        final playlist = await spotify.playlists.createPlaylist(
          me.data!.id!,
          variable.playlistName,
          collaborative: variable.collaborative,
          description: variable.description,
          public: variable.public,
        );

        if (variable.base64Image != null) {
          await spotify.playlists.updatePlaylistImage(
            playlist.id!,
            variable.base64Image!,
          );
        }

        if (trackIds != null && trackIds.isNotEmpty) {
          await spotify.playlists.addTracks(
            trackIds.map((id) => "spotify:track:$id").toList(),
            playlist.id!,
          );
        }

        return playlist;
      },
      refreshInfiniteQueries: ["current-user-playlists"],
      refreshQueries: ["current-user-all-playlists"],
      ref: ref,
      onError: (error, recoveryData) {
        onError?.call(error);
      },
      onData: (data, recoveryData) {
        onData?.call(data);
      },
    );
  }

  Mutation<void, dynamic, PlaylistCRUDVariables> update(
    WidgetRef ref, {
    String? playlistId,
    ValueChanged<dynamic>? onError,
    ValueChanged<void>? onData,
  }) {
    return useSpotifyMutation<void, dynamic, PlaylistCRUDVariables, void>(
      "update-playlist/$playlistId",
      (variable, spotify) async {
        if (playlistId == null) return;
        await spotify.playlists.updatePlaylist(
          playlistId,
          variable.playlistName,
          collaborative: variable.collaborative,
          description: variable.description,
          public: variable.public,
        );
        if (variable.base64Image != null) {
          await spotify.playlists.updatePlaylistImage(
            playlistId,
            variable.base64Image!,
          );
        }
      },
      refreshInfiniteQueries: [
        "playlist/$playlistId",
        "current-user-playlists",
      ],
      refreshQueries: ["current-user-all-playlists"],
      ref: ref,
      onError: (error, recoveryData) {
        onError?.call(error);
      },
      onData: (data, recoveryData) {
        onData?.call(data);
      },
    );
  }
}
