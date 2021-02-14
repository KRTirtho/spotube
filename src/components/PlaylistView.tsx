import React, { FC, useContext, useEffect, useState } from "react";
import { BoxView, Button, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import BackButton from "./BackButton";
import { useLocation, useParams } from "react-router";
import { Direction, QAbstractButtonSignals } from "@nodegui/nodegui";
import { WidgetEventListeners } from "@nodegui/react-nodegui/dist/components/View/RNView";
import authContext from "../context/authContext";
import playerContext from "../context/playerContext";

export interface PlaylistTrackRes {
  name: string;
  artists: string;
  url: string;
}

interface PlaylistViewProps {
  // audioPlayer: any;
}

const PlaylistView: FC<PlaylistViewProps> = () => {
  const { isLoggedIn, access_token } = useContext(authContext);
  const { spotifyApi, setCurrentTrack, currentPlaylist, currentTrack, setCurrentPlaylist } = useContext(playerContext);
  const params = useParams<{ id: string }>();
  const location = useLocation<{ name: string, thumbnail: string }>();
  const [tracks, setTracks] = useState<SpotifyApi.PlaylistTrackObject[]>([]);

  const trackClickHandler = async (track: SpotifyApi.TrackObjectFull) => {
    try {
      setCurrentTrack(track);
      if (currentPlaylist?.id !== params.id) {
        setCurrentPlaylist({...params, ...location.state, tracks});
      }
    } catch (error) {
      console.error("Failed to resolve track's youtube url: ", error);
    }
  };

  useEffect(() => {
    if (isLoggedIn) {
      (async () => {
        try {
          spotifyApi.setAccessToken(access_token);
          const tracks = await spotifyApi.getPlaylistTracks(params.id);
          setTracks(tracks.body.items);
        } catch (error) {
          console.error(`Failed to get tracks from ${params.id}: `, error);
        }
      })();
    }
  }, []);

  return (
    <BoxView direction={Direction.TopToBottom}>
      <BackButton />
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
    </BoxView>
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
