import { QIcon, QMouseEvent } from "@nodegui/nodegui";
import { Text, View } from "@nodegui/react-nodegui";
import React, { FC, useContext, useMemo } from "react";
import playerContext from "../../context/playerContext";
import { msToMinAndSec } from "../../helpers/msToMin:sec";
import useTrackReaction from "../../hooks/useTrackReaction";
import { heart, heartRegular, pause, play } from "../../icons";
import { audioPlayer } from "../Player";
import IconButton from "./IconButton";

export interface TrackButtonProps {
  track: SpotifyApi.TrackObjectFull;
  playlist?: SpotifyApi.PlaylistObjectFull;
  index: number;
}

export const TrackButton: FC<TrackButtonProps> = ({ track, index, playlist }) => {
  const { reactToTrack, isFavorite } = useTrackReaction();
  const { currentPlaylist, setCurrentPlaylist, setCurrentTrack, currentTrack } = useContext(playerContext);
  const handlePlaylistPlayPause = (index?: number) => {
    if (currentPlaylist?.id !== playlist?.id && playlist?.tracks) {
      setCurrentPlaylist({ id: playlist.id, name: playlist.name, thumbnail: playlist.images[0].url, tracks: playlist.tracks.items });
      setCurrentTrack(playlist.tracks.items[index ?? 0].track);
    } else {
      audioPlayer.stop().catch((error) => console.error("Failed to stop audio player: ", error));
      setCurrentTrack(undefined);
      setCurrentPlaylist(undefined);
    }
  };

  const trackClickHandler = (track: SpotifyApi.TrackObjectFull) => {
    setCurrentTrack(track);
  };

  const duration = useMemo(() => msToMinAndSec(track.duration_ms), []);
  const active = (currentPlaylist?.id === playlist?.id && currentTrack?.id === track.id) || currentTrack?.id === track.id;
  return (
    <View
      id={active?"active":"track-button"}
      styleSheet={trackButtonStyle}
      on={{
        MouseButtonRelease(native: any) {
          if (new QMouseEvent(native).button() === 1 && playlist) {
            handlePlaylistPlayPause(index);
          }
        },
      }}>
      <Text style="padding: 5px;">{index + 1}</Text>
      <View style="flex-direction: 'column'; width: '35%';">
        <Text>{`<h3>${track.name}</h3>`}</Text>
        <Text>{track.artists.map((artist) => artist.name).join(", ")}</Text>
      </View>
      <Text style="width: '25%';">{track.album.name}</Text>
      <Text style="width: '15%';">{duration}</Text>
      <View style="width: '15%'; padding: 5px; justify-content: 'space-around';">
        <IconButton
          icon={new QIcon(isFavorite(track.id) ? heart : heartRegular)}
          on={{
            clicked() {
              reactToTrack({ track, added_at: "" });
            },
          }}
        />
        <IconButton
          icon={new QIcon(active ? pause : play)}
          on={{
            clicked() {
              trackClickHandler(track);
            },
          }}
        />
      </View>
    </View>
  );
};

const trackButtonStyle = `
  #active{
    background-color: #34eb71;
    color: #333;
  }
  #track-button:hover{
    background-color: rgba(229, 224, 224, 0.48);
  }
`;
