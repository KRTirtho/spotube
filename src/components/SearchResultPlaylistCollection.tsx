import React from "react";
import { useLocation } from "react-router";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import { GenreView } from "./PlaylistGenreView";

function SearchResultPlaylistCollection() {
    const location = useLocation<{ searchQuery: string }>();
    const {
        data: searchResults,
        fetchNextPage,
        hasNextPage,
        isFetchingNextPage,
        isError,
        isLoading,
        refetch,
    } = useSpotifyInfiniteQuery<SpotifyApi.SearchResponse>(
        QueryCacheKeys.searchPlaylist,
        (spotifyApi, { pageParam }) =>
            spotifyApi
                .searchPlaylists(location.state.searchQuery, {
                    limit: 20,
                    offset: pageParam,
                })
                .then((res) => res.body),
        {
            getNextPageParam: (lastPage) => {
                if (lastPage.playlists?.next) {
                    return (
                        (lastPage.playlists?.offset ?? 0) +
                        (lastPage.playlists?.limit ?? 0)
                    );
                }
            },
        },
    );
    return (
        <GenreView
            isError={isError}
            isLoading={isLoading || isFetchingNextPage}
            refetch={refetch}
            heading={"Search: " + location.state.searchQuery}
            playlists={
                (searchResults?.pages
                    ?.map((page) => page.playlists?.items)
                    .filter(Boolean)
                    .flat(1) as SpotifyApi.PlaylistObjectSimplified[]) ?? []
            }
            loadMore={hasNextPage ? () => fetchNextPage() : undefined}
            isLoadable={!isFetchingNextPage}
        />
    );
}

export default SearchResultPlaylistCollection;
