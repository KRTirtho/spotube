import { QIcon } from "@nodegui/nodegui";
import { LineEdit, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useState } from "react";
import { QueryCacheKeys } from "../conf";
import showError from "../helpers/showError";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import { search } from "../icons";
import { PlaylistCard } from "./Home";
import { TrackButton, TrackTableIndex } from "./PlaylistView";
import IconButton from "./shared/IconButton";

function Search() {
  const [searchQuery, setSearchQuery] = useState<string>("");
  const { data: searchResults, isError, refetch } = useSpotifyQuery<SpotifyApi.SearchResponse>(
    QueryCacheKeys.search,
    (spotifyApi) => spotifyApi.search(searchQuery, ["playlist", "track"]).then((res) => res.body),
    { enabled: false }
  );

  async function handleSearch() {
    try {
      await refetch();
    } catch (error) {
      showError(error, "[Failed to search through spotify]: ");
    }
  }

  return (
    <View style="flex: 1; flex-direction: 'column'; padding: 5px;">
      <View>
        <LineEdit
          style="width: '65%'; margin: 5px;"
          placeholderText="Search spotify"
          on={{
            textChanged(t) {
              setSearchQuery(t);
            },
          }}
        />
        <IconButton enabled={searchQuery.length > 0} icon={new QIcon(search)} on={{ clicked: handleSearch }} />
      </View>
      <ScrollArea style="flex: 1;">
        <View style="flex-direction: 'column'; flex: 1;">
          <View style="flex: 1; flex-direction: 'column';">
            <Text>{`<h2>Songs</h2>`}</Text>
            <TrackTableIndex />
            {searchResults?.tracks?.items.map((track, index) => (
              <TrackButton active={false} index={index} track={track} on={{}} onTrackClick={() => {}} />
            ))}
          </View>
          <View style="flex: 1; flex-direction: 'column';">
            <Text>{`<h2>Playlists</h2>`}</Text>
            <ScrollArea style="flex: 1;">
              <View style="flex-direction: 'row'; align-items: 'center'; flex-wrap: 'wrap'; width: 330px;">
                {searchResults?.playlists?.items.map((playlist) => (
                  <PlaylistCard playlist={playlist} />
                ))}
              </View>
            </ScrollArea>
          </View>
        </View>
      </ScrollArea>
    </View>
  );
}

export default Search;
