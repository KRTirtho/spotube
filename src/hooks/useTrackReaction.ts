import { useQueryClient } from "react-query";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "./useSpotifyInfiniteQuery";
import useSpotifyMutation from "./useSpotifyMutation";
import useSpotifyQuery from "./useSpotifyQuery";

function useTrackReaction() {
  const queryClient = useQueryClient();
  const { data: userSavedTracks } = useSpotifyInfiniteQuery<SpotifyApi.UsersSavedTracksResponse>(QueryCacheKeys.userSavedTracks, (spotifyApi, { pageParam }) =>
    spotifyApi.getMySavedTracks({ limit: 50, offset: pageParam }).then((res) => res.body)
  );
  const favoriteTracks = userSavedTracks?.pages
    ?.map((page) => page.items)
    .filter(Boolean)
    .flat(1) as SpotifyApi.SavedTrackObject[] | undefined;
  const { mutate: reactToTrack } = useSpotifyMutation<{}, SpotifyApi.SavedTrackObject>(
    (spotifyApi, { track }) => spotifyApi[isFavorite(track.id) ? "removeFromMySavedTracks" : "addToMySavedTracks"]([track.id]).then((res) => res.body),
    {
      onSuccess(_, track) {
        queryClient.setQueryData<SpotifyApi.SavedTrackObject[]>(
          QueryCacheKeys.userSavedTracks,
          isFavorite(track.track.id) ? (old) => (old ?? []).filter((oldTrack) => oldTrack.track.id !== track.track.id) : (old) => [...(old ?? []), track]
        );
      },
    }
  );
  const favoriteTrackIds = favoriteTracks?.map((track) => track.track.id);

  function isFavorite(trackId: string) {
    return favoriteTrackIds?.includes(trackId);
  }

  return { reactToTrack, isFavorite, favoriteTracks };
}

export default useTrackReaction;
