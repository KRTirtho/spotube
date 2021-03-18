import React, { useState } from "react";
import { useLocation } from "react-router";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import { GenreView } from "./PlaylistGenreView";

function SearchResultPlaylistCollection() {
  const location = useLocation<{ searchQuery: string }>();
  const { data: searchResults, fetchNextPage, hasNextPage, isFetchingNextPage } = useSpotifyInfiniteQuery<SpotifyApi.SearchResponse>(
    QueryCacheKeys.searchPlaylist,
    (spotifyApi, { pageParam }) => spotifyApi.searchPlaylists(location.state.searchQuery, { limit: 20, offset: pageParam }).then((res) => res.body),
    {
      getNextPageParam: (lastPage) => {
        return (lastPage.playlists?.offset ?? 0) + 1;
      },
    }
  );
  return (
    <GenreView
      heading={"Search: "+location.state.searchQuery}
      playlists={
        (searchResults?.pages
          ?.map((page) => page.playlists?.items)
          .filter(Boolean)
          .flat(1) as SpotifyApi.PlaylistObjectSimplified[]) ?? []
      }
      loadMore={() => {
        fetchNextPage();
      }}
      isLoadable={hasNextPage || !isFetchingNextPage}
    />
  );
}

export default SearchResultPlaylistCollection;
