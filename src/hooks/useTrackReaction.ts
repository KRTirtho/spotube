import { useQueryClient } from "react-query";
import { QueryCacheKeys } from "../conf";
import useSpotifyMutation from "./useSpotifyMutation";
import useSpotifyQuery from "./useSpotifyQuery";

function useTrackReaction() {
  const queryClient = useQueryClient();
  const { data: favoriteTracks } = useSpotifyQuery<SpotifyApi.SavedTrackObject[]>(QueryCacheKeys.userSavedTracks, (spotifyApi) =>
    spotifyApi.getMySavedTracks({ limit: 50 }).then((tracks) => tracks.body.items)
  );
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
