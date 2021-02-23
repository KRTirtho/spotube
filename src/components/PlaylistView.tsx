import React, { FC, useContext, useEffect, useState } from "react";
import { Button, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import BackButton from "./BackButton";
import { useLocation, useParams } from "react-router";
import { QAbstractButtonSignals, QIcon } from "@nodegui/nodegui";
import { WidgetEventListeners } from "@nodegui/react-nodegui/dist/components/View/RNView";
import authContext from "../context/authContext";
import playerContext from "../context/playerContext";
import IconButton from "./shared/IconButton";
import { heartRegular, play, stop } from "../icons";
import { audioPlayer } from "./Player";
import useSpotifyApi from "../hooks/useSpotifyApi";

export interface PlaylistTrackRes {
  name: string;
  artists: string;
  url: string;
}

const PlaylistView: FC = () => {
  const { isLoggedIn } = useContext(authContext);
  const { setCurrentTrack, currentPlaylist, currentTrack, setCurrentPlaylist } = useContext(playerContext);
  const spotifyApi = useSpotifyApi();
  const params = useParams<{ id: string }>();
  const location = useLocation<{ name: string; thumbnail: string }>();
  const [tracks, setTracks] = useState<SpotifyApi.PlaylistTrackObject[]>([]);

  useEffect(() => {
    if (isLoggedIn) {
      (async () => {
        try {
          const tracks = await spotifyApi.getPlaylistTracks(params.id);
          setTracks(tracks.body.items);
        } catch (error) {
          console.error(`Failed to get tracks from ${params.id}: `, error);
        }
      })();
    }
  }, []);

  const handlePlaylistPlayPause = () => {
    if (currentPlaylist?.id !== params.id) {
      setCurrentPlaylist({ ...params, ...location.state, tracks });
      setCurrentTrack(tracks[0].track);
    } else {
      audioPlayer.stop().catch((error) => console.error("Failed to stop audio player: ", error));
      setCurrentTrack(undefined);
      setCurrentPlaylist(undefined);
    }
  };

  const trackClickHandler = async (track: SpotifyApi.TrackObjectFull) => {
    try {
      setCurrentTrack(track);
    } catch (error) {
      console.error("Failed to resolve track's youtube url: ", error);
    }
  };

  return (
    <View style={`flex-direction: 'column'; flex-grow: 1;`}>
      <View style={`justify-content: 'space-between'; padding-bottom: 10px; padding-left: 10px;`}>
        <BackButton />
        <View style={`height: 50px; justify-content: 'space-between'; width: 100px; padding-right: 20px;`}>
          <IconButton icon={new QIcon(heartRegular)} />
          <IconButton style={`background-color: #00be5f; color: white;`} on={{ clicked: handlePlaylistPlayPause }} icon={new QIcon(currentPlaylist?.id === params.id ? stop : play)} />
        </View>
      </View>
      <Text>{`<center><h2>${location.state.name[0].toUpperCase()}${location.state.name.slice(1)}</h2></center>`}</Text>
      <ScrollArea style={`flex-grow: 1; border: none;`}>
        <View style={`flex-direction:column;`}>
          {isLoggedIn &&
            tracks.length > 0 &&
            tracks.map(({ track }, index) => {
              return (
                <TrackButton
                  key={index * ((Date.now() / Math.random()) * 100)}
                  active={currentTrack?.id === track.id && currentPlaylist?.id === params.id}
                  artist={track.artists.map((x) => x.name).join(", ")}
                  name={track.name}
                  on={{ clicked: () => trackClickHandler(track) }}
                />
              );
            })}
        </View>
      </ScrollArea>
    </View>
  );
};

interface TrackButtonProps {
  name: string;
  artist: string;
  active: boolean;
  on: Partial<QAbstractButtonSignals | WidgetEventListeners>;
}

const TrackButton: FC<TrackButtonProps> = ({ name, artist, on, active }) => {
  return <Button id={`${active ? "active" : ""}`} on={on} text={`${name} -- ${artist}`} styleSheet={trackButtonStyle} />;
};

const trackButtonStyle = `
  #active{
    background-color: orange;
    color: #333;
  }
`;

export default PlaylistView;
