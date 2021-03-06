import { ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useContext } from "react";
import playerContext from "../context/playerContext";
import { TrackButton } from "./PlaylistView";

function CurrentPlaylist() {
  const { currentPlaylist, currentTrack, setCurrentTrack } = useContext(playerContext);

  if (!currentPlaylist && !currentTrack) {
    return <Text style="flex: 1;">{`<center>There is nothing being played now</center>`}</Text>;
  }

  return (
    <View style="flex: 1; flex-direction: 'column';">
      <Text>{ `<center><h2>${currentPlaylist?.name}</h2></center>` }</Text>
      <ScrollArea style={`flex:1; flex-grow: 1; border: none;`}>
        <View style={`flex-direction:column; flex: 1;`}>
          {currentPlaylist?.tracks.map(({ track }, index) => {
            return (
              <TrackButton
                key={index + track.id}
                active={currentTrack?.id === track.id}
                artist={track.artists.map((x) => x.name).join(", ")}
                name={track.name}
                on={{ clicked: () => setCurrentTrack(track) }}
              />
            );
          })}
        </View>
      </ScrollArea>
    </View>
  );
}

export default CurrentPlaylist;
