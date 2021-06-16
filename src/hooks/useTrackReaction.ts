import { InfiniteData, useQueryClient } from "react-query";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "./useSpotifyInfiniteQuery";
import useSpotifyMutation from "./useSpotifyMutation";

function useTrackReaction() {
    const queryClient = useQueryClient();
    const { data: userSavedTracks } =
        useSpotifyInfiniteQuery<SpotifyApi.UsersSavedTracksResponse>(
            QueryCacheKeys.userSavedTracks,
            (spotifyApi, { pageParam }) =>
                spotifyApi
                    .getMySavedTracks({ limit: 50, offset: pageParam })
                    .then((res) => res.body),
        );
    const favoriteTracks = userSavedTracks?.pages
        ?.map((page) => page.items)
        .filter(Boolean)
        .flat(1) as SpotifyApi.SavedTrackObject[] | undefined;

    function updateFunction(
        track: SpotifyApi.SavedTrackObject,
        old?: InfiniteData<SpotifyApi.UsersSavedTracksResponse>,
    ): InfiniteData<SpotifyApi.UsersSavedTracksResponse> {
        const obj: typeof old = {
            pageParams: old?.pageParams ?? [],
            pages:
                old?.pages.map((oldPage, index): SpotifyApi.UsersSavedTracksResponse => {
                    const isTrackFavorite = isFavorite(track.track.id);
                    if (index === 0 && !isTrackFavorite) {
                        return { ...oldPage, items: [...oldPage.items, track] };
                    } else if (isTrackFavorite) {
                        return {
                            ...oldPage,
                            items: oldPage.items.filter(
                                (oldTrack) => oldTrack.track.id !== track.track.id,
                            ),
                        };
                    }
                    return oldPage;
                }) ?? [],
        };
        return obj;
    }

    const { mutate: reactToTrack } = useSpotifyMutation<
        unknown,
        SpotifyApi.SavedTrackObject
    >(
        (spotifyApi, { track }) =>
            spotifyApi[
                isFavorite(track.id) ? "removeFromMySavedTracks" : "addToMySavedTracks"
            ]([track.id]).then((res) => res.body),
        {
            onSuccess(_, track) {
                queryClient.setQueryData<
                    InfiniteData<SpotifyApi.UsersSavedTracksResponse>
                >(QueryCacheKeys.userSavedTracks, (old) => updateFunction(track, old));
            },
        },
    );
    const favoriteTrackIds = favoriteTracks?.map((track) => track.track.id);

    function isFavorite(trackId: string) {
        return favoriteTrackIds?.includes(trackId);
    }

    return { reactToTrack, isFavorite, favoriteTracks };
}

export default useTrackReaction;
