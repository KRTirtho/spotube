import React, { FC, useContext } from "react";
import { View, Button, ScrollArea, Text } from "@nodegui/react-nodegui";
import BackButton from "./BackButton";
import { useLocation, useParams } from "react-router";
import { QAbstractButtonSignals, QIcon } from "@nodegui/nodegui";
import { WidgetEventListeners } from "@nodegui/react-nodegui/dist/components/View/RNView";
import playerContext from "../context/playerContext";
import IconButton from "./shared/IconButton";
import { heartRegular, play, stop } from "../icons";
import { audioPlayer } from "./Player";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";

export interface PlaylistTrackRes {
  name: string;
  artists: string;
  url: string;
}

const PlaylistView: FC = () => {
  const { setCurrentTrack, currentPlaylist, currentTrack, setCurrentPlaylist } = useContext(playerContext);
  const params = useParams<{ id: string }>();
  const location = useLocation<{ name: string; thumbnail: string }>();

  const { data: tracks, isSuccess, isError, isLoading, refetch } = useSpotifyQuery<SpotifyApi.PlaylistTrackObject[]>(
    [QueryCacheKeys.playlistTracks, params.id],
    (spotifyApi) => spotifyApi.getPlaylistTracks(params.id).then((track) => track.body.items),
    { initialData: [] }
  );

  const handlePlaylistPlayPause = () => {
    if (currentPlaylist?.id !== params.id && isSuccess && tracks) {
      setCurrentPlaylist({ ...params, ...location.state, tracks });
      setCurrentTrack(tracks[0].track);
    } else {
      audioPlayer.stop().catch((error) => console.error("Failed to stop audio player: ", error));
      setCurrentTrack(undefined);
      setCurrentPlaylist(undefined);
    }
  };

  const trackClickHandler = (track: SpotifyApi.TrackObjectFull) => {
    setCurrentTrack(track);
  };

  return (
    <View style={`flex: 1; flex-direction: 'column';`}>
      <PlaylistSimpleControls handlePlaylistPlayPause={handlePlaylistPlayPause} isActive={currentPlaylist?.id === params.id} />
      <Text>{`<center><h2>${location.state.name[0].toUpperCase()}${location.state.name.slice(1)}</h2></center>`}</Text>
      <ScrollArea style={`flex:1; flex-grow: 1; border: none;`}>
        <View style={`flex-direction:column; flex: 1;`}>
          {isLoading && <Text>{`Loading Tracks...`}</Text>}
          {isError && (
            <>
              <Text>{`Failed to load ${location.state.name} tracks`}</Text>
              <Button
                on={{
                  clicked() {
                    refetch();
                  },
                }}
                text="Retry"
              />
            </>
          )}
          {tracks?.map(({ track }, index) => {
            return (
              <TrackButton
                key={index + track.id}
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

export interface TrackButtonProps {
  name: string;
  artist: string;
  active: boolean;
  on: Partial<QAbstractButtonSignals | WidgetEventListeners>;
}

export const TrackButton: FC<TrackButtonProps> = ({ name, artist, on, active }) => {
  return <Button id={`${active ? "active" : ""}`} on={on} text={`${name} -- ${artist}`} styleSheet={trackButtonStyle} />;
};

const trackButtonStyle = `
  #active{
    background-color: orange;
    color: #333;
  }
`;

export default PlaylistView;

interface PlaylistSimpleControlsProps {
  handlePlaylistPlayPause: () => void;
  isActive: boolean;
}

export function PlaylistSimpleControls({ handlePlaylistPlayPause, isActive }: PlaylistSimpleControlsProps) {
  return (
    <View style={`justify-content: 'space-evenly'; max-width: 150px; padding: 10px;`}>
      <BackButton />
      <IconButton icon={new QIcon(heartRegular)} />
      <IconButton style={`background-color: #00be5f; color: white;`} on={{ clicked: handlePlaylistPlayPause }} icon={new QIcon(isActive ? stop : play)} />
    </View>
  );
}
