import { InfiniteData, useQueryClient } from "react-query";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "./useSpotifyInfiniteQuery";
import useSpotifyMutation from "./useSpotifyMutation";

function usePlaylistReaction() {
  const queryClient = useQueryClient();
  const { data: favoritePagedPlaylists } = useSpotifyInfiniteQuery<SpotifyApi.ListOfUsersPlaylistsResponse>(QueryCacheKeys.userPlaylists, (spotifyApi, { pageParam }) =>
    spotifyApi.getUserPlaylists({ limit: 20, offset: pageParam }).then((userPlaylists) => {
      return userPlaylists.body;
    })
  );
  const favoritePlaylists = favoritePagedPlaylists?.pages
    .map((playlist) => playlist.items)
    .filter(Boolean)
    .flat(1) as SpotifyApi.PlaylistObjectSimplified[];

  function updateFunction(playlist: SpotifyApi.PlaylistObjectSimplified, old?: InfiniteData<SpotifyApi.ListOfUsersPlaylistsResponse>): InfiniteData<SpotifyApi.ListOfUsersPlaylistsResponse> {
    const obj: typeof old = {
      pageParams: old?.pageParams ?? [],
      pages:
        old?.pages.map(
          (oldPage, index): SpotifyApi.ListOfUsersPlaylistsResponse => {
            const isPlaylistFavorite = isFavorite(playlist.id);
            if (index === 0 && !isPlaylistFavorite) {
              return { ...oldPage, items: [...oldPage.items, playlist] };
            } else if (isPlaylistFavorite) {
              return { ...oldPage, items: oldPage.items.filter((oldPlaylist) => oldPlaylist.id !== playlist.id) };
            }
            return oldPage;
          }
        ) ?? [],
    };
    return obj;
  }

  const { mutate: reactToPlaylist } = useSpotifyMutation<{}, SpotifyApi.PlaylistObjectSimplified>(
    (spotifyApi, { id }) => spotifyApi[isFavorite(id) ? "unfollowPlaylist" : "followPlaylist"](id).then((res) => res.body),
    {
      onSuccess(_, playlist) {
        queryClient.setQueryData<InfiniteData<SpotifyApi.ListOfUsersPlaylistsResponse>>(QueryCacheKeys.userPlaylists, (old) => updateFunction(playlist, old));
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
