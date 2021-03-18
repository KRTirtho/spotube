import { QIcon, QMouseEvent } from "@nodegui/nodegui";
import { LineEdit, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useState } from "react";
import { useHistory } from "react-router";
import { QueryCacheKeys } from "../conf";
import showError from "../helpers/showError";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import { search } from "../icons";
import { PlaylistCard } from "./Home";
import { TrackButton, TrackTableIndex } from "./PlaylistView";
import IconButton from "./shared/IconButton";

function Search() {
  const history = useHistory<{ searchQuery: string }>();
  const [searchQuery, setSearchQuery] = useState<string>("");
  const { data: searchResults, isError, refetch } = useSpotifyQuery<SpotifyApi.SearchResponse>(
    QueryCacheKeys.search,
    (spotifyApi) => spotifyApi.search(searchQuery, ["playlist", "track"], { limit: 4 }).then((res) => res.body),
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
              <TrackButton key={index+track.id} active={false} index={index} track={track} on={{}} onTrackClick={() => {}} />
            ))}
          </View>
          <View style="flex: 1; flex-direction: 'column';">
            <Text
              on={{
                MouseButtonRelease(native: any) {
                  if (new QMouseEvent(native).button() === 1) {
                    history.push("/search/playlists", { searchQuery });
                  }
                },
              }}>{`<h2>Playlists</h2>`}</Text>
            <View style="flex: 1; justify-content: 'space-around'; align-items: 'center';">
              {searchResults?.playlists?.items.map((playlist, index) => (
                <PlaylistCard key={index+playlist.id} playlist={playlist} />
              ))}
            </View>
          </View>
        </View>
      </ScrollArea>
    </View>
  );
}

export default Search;
