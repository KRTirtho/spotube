import { useQueryClient } from "react-query";
import { QueryCacheKeys } from "../conf";
import useSpotifyMutation from "./useSpotifyMutation";
import useSpotifyQuery from "./useSpotifyQuery";

function usePlaylistReaction() {
  const queryClient = useQueryClient();
  const { data: favoritePlaylists } = useSpotifyQuery<SpotifyApi.PlaylistObjectSimplified[]>(QueryCacheKeys.userPlaylists, (spotifyApi) =>
    spotifyApi.getUserPlaylists().then((userPlaylists) => userPlaylists.body.items)
  );
  const { mutate: reactToPlaylist } = useSpotifyMutation<{}, SpotifyApi.PlaylistObjectSimplified>(
    (spotifyApi, { id }) => spotifyApi[isFavorite(id) ? "unfollowPlaylist" : "followPlaylist"](id).then((res) => res.body),
    {
      onSuccess(_, playlist) {
        queryClient.setQueryData<SpotifyApi.PlaylistObjectSimplified[]>(
          QueryCacheKeys.userPlaylists,
          isFavorite(playlist.id) ? (old) => (old ?? []).filter((oldPlaylist) => oldPlaylist.id !== playlist.id) : (old) => [...(old ?? []), playlist]
        );
      },
    }
  );
  const favoritePlaylistIds = favoritePlaylists?.map((playlist) => playlist.id);

  function isFavorite(playlistId: string) {
    return favoritePlaylistIds?.includes(playlistId);
  }

  return { reactToPlaylist, isFavorite, favoritePlaylists };
}

export default usePlaylistReaction;
