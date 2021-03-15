import { Direction } from "@nodegui/nodegui";
import { BoxView, ScrollArea, Text, View, GridView, GridColumn, GridRow } from "@nodegui/react-nodegui";
import React from "react";
import { useLocation, useParams } from "react-router";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import BackButton from "./BackButton";
import { PlaylistCard } from "./Home";

function PlaylistGenreView() {
  const { id } = useParams<{ id: string }>();
  const location = useLocation<{ name: string }>();
  const { data: playlists } = useSpotifyQuery<SpotifyApi.PlaylistObjectSimplified[]>(
    [QueryCacheKeys.genrePlaylists, id],
    (spotifyApi) => spotifyApi.getPlaylistsForCategory(id)
      .then((playlistsRes) => playlistsRes.body.playlists.items),
    { initialData: [] }
  )

  const playlistGenreViewStylesheet = `
    #genre-container{
      flex-direction: column;
      flex: 1;
    }
    #heading {
      padding: 10px;
    }
    #scroll-view{
      flex: 1;
      flex-grow: 1;
      border: none;
    }
    #child-container {
      flex-direction: "row";
      justify-content: "space-evenly";
      align-items: 'center';
      flex-wrap: "wrap";
      width: 330px;
    }
  `;

  return (
    <View id="genre-container" styleSheet={playlistGenreViewStylesheet}>
      <BackButton />
      <Text id="heading">{`<h2>${location.state.name}</h2>`}</Text>
      <ScrollArea id="scroll-view">
        <View id="child-container">
          {playlists?.map((playlist, index) => {
            return (
              <PlaylistCard
                key={index + playlist.id}
                playlist={playlist}
              />
          );
          })}
        </View>
      </ScrollArea>
    </View>
  );
}

export default PlaylistGenreView;
