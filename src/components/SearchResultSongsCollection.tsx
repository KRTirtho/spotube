import { Button, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React from "react";
import { useLocation } from "react-router";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import { TrackTableIndex } from "./PlaylistView";
import PlaceholderApplet from "./shared/PlaceholderApplet";
import { TrackButton } from "./shared/TrackButton";

function SearchResultSongsCollection() {
  const location = useLocation<{ searchQuery: string }>();
  const { data: searchResults, fetchNextPage, hasNextPage, isFetchingNextPage, isError, isLoading, refetch } = useSpotifyInfiniteQuery<SpotifyApi.SearchResponse>(
    QueryCacheKeys.searchSongs,
    (spotifyApi, { pageParam }) => spotifyApi.searchTracks(location.state.searchQuery, { limit: 20, offset: pageParam }).then((res) => res.body),
    {
      getNextPageParam: (lastPage) => {
        if (lastPage.tracks?.next) {
          return (lastPage.tracks?.offset ?? 0) + (lastPage.tracks?.limit ?? 0);
        }
      },
    }
  );
  return (
    <View style="flex: 1; flex-direction: 'column';">
      <Text>{`
      <center>
        <h2>Search: ${location.state.searchQuery}</h2>
      </center>
      `}</Text>
      <TrackTableIndex />
      <ScrollArea style="flex: 1; border: none;">
        <View style="flex: 1; flex-direction: 'column';">
          <PlaceholderApplet error={isError} loading={isLoading || isFetchingNextPage} message="Failed querying spotify" reload={refetch} />
          {searchResults?.pages
            .map((searchResult) => searchResult.tracks?.items)
            .filter(Boolean)
            .flat(1)
            .map((track, index) => track && <TrackButton key={index + track.id} index={index} track={track} />)}

          {hasNextPage && (
            <Button
              style="flex-grow: 0; align-self: 'center';"
              text="Load more"
              on={{
                clicked() {
                  fetchNextPage();
                },
              }}
              enabled={!isFetchingNextPage}
            />
          )}
        </View>
      </ScrollArea>
    </View>
  );
}

export default SearchResultSongsCollection;
