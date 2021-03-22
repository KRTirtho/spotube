import { ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useContext } from "react";
import playerContext from "../context/playerContext";
import { TrackTableIndex } from "./PlaylistView";
import { TrackButton } from "./shared/TrackButton";

function CurrentPlaylist() {
  const { currentPlaylist, currentTrack } = useContext(playerContext);

  if (!currentPlaylist && !currentTrack) {
    return <Text style="flex: 1;">{`<center>There is nothing being played now</center>`}</Text>;
  }

  if (currentTrack && !currentPlaylist) {
    <View style="flex: 1;">
      <TrackButton track={currentTrack} index={0}/>
    </View>
  }

  return (
    <View style="flex: 1; flex-direction: 'column';">
      <Text>{`<center><h2>${currentPlaylist?.name}</h2></center>`}</Text>
      <TrackTableIndex />
      <ScrollArea style={`flex:1; flex-grow: 1; border: none;`}>
        <View style={`flex-direction:column; flex: 1;`}>
          {currentPlaylist?.tracks.map(({ track }, index) => {
            return <TrackButton key={index + track.id} track={track} index={index} />;
          })}
        </View>
      </ScrollArea>
    </View>
  );
}

export default CurrentPlaylist;
