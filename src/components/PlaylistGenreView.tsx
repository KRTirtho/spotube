import { QAbstractButtonSignals } from "@nodegui/nodegui";
import { Button, ScrollArea, Text, View } from "@nodegui/react-nodegui";
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
    (spotifyApi) => spotifyApi.getPlaylistsForCategory(id).then((playlistsRes) => playlistsRes.body.playlists.items),
    { initialData: [] }
  );

  return <GenreView heading={location.state.name} playlists={playlists ?? []} />;
}

export default PlaylistGenreView;

interface GenreViewProps {
  heading: string;
  playlists: SpotifyApi.PlaylistObjectSimplified[];
  loadMore?: QAbstractButtonSignals["clicked"];
  isLoadable?: boolean;
}

export function GenreView({ heading, playlists, loadMore, isLoadable }: GenreViewProps) {
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
      <Text id="heading">{`<h2>${heading}</h2>`}</Text>
      <ScrollArea id="scroll-view">
        <View id="child-container">
          {playlists?.map((playlist, index) => {
            return <PlaylistCard key={index + playlist.id} playlist={playlist} />;
          })}
          {loadMore && <Button text="Load more" on={{ clicked: loadMore }} enabled={isLoadable} />}
        </View>
      </ScrollArea>
    </View>
  );
}
