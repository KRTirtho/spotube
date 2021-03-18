import React, { FC, useContext, useMemo } from "react";
import { View, Button, ScrollArea, Text } from "@nodegui/react-nodegui";
import BackButton from "./BackButton";
import { useLocation, useParams } from "react-router";
import { QAbstractButtonSignals, QIcon, QMouseEvent, QWidgetSignals } from "@nodegui/nodegui";
import { WidgetEventListeners } from "@nodegui/react-nodegui/dist/components/View/RNView";
import playerContext from "../context/playerContext";
import IconButton from "./shared/IconButton";
import { heart, heartRegular, pause, play, stop } from "../icons";
import { audioPlayer } from "./Player";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import useTrackReaction from "../hooks/useTrackReaction";
import usePlaylistReaction from "../hooks/usePlaylistReaction";
import { msToMinAndSec } from "../helpers/msToMin:sec";

export interface PlaylistTrackRes {
  name: string;
  artists: string;
  url: string;
}

const PlaylistView: FC = () => {
  const { setCurrentTrack, currentPlaylist, currentTrack, setCurrentPlaylist } = useContext(playerContext);
  const params = useParams<{ id: string }>();
  const location = useLocation<{ name: string; thumbnail: string }>();
  const { isFavorite, reactToPlaylist } = usePlaylistReaction();
  const { data: playlist } = useSpotifyQuery<SpotifyApi.PlaylistObjectFull>([QueryCacheKeys.categoryPlaylists, params.id], (spotifyApi) =>
    spotifyApi.getPlaylist(params.id).then((playlistsRes) => playlistsRes.body)
  );
  const { data: tracks, isSuccess, isError, isLoading, refetch } = useSpotifyQuery<SpotifyApi.PlaylistTrackObject[]>(
    [QueryCacheKeys.playlistTracks, params.id],
    (spotifyApi) => spotifyApi.getPlaylistTracks(params.id).then((track) => track.body.items),
    { initialData: [] }
  );

  const handlePlaylistPlayPause = (index?: number) => {
    if (currentPlaylist?.id !== params.id && isSuccess && tracks) {
      setCurrentPlaylist({ ...params, ...location.state, tracks });
      setCurrentTrack(tracks[index ?? 0].track);
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
      <PlaylistSimpleControls
        handlePlaylistReact={() => playlist && reactToPlaylist(playlist)}
        handlePlaylistPlayPause={handlePlaylistPlayPause}
        isActive={currentPlaylist?.id === params.id}
        isFavorite={isFavorite(params.id)}
      />
      <Text>{`<center><h2>${location.state.name[0].toUpperCase()}${location.state.name.slice(1)}</h2></center>`}</Text>
      {<TrackTableIndex />}
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
            if (track) {
              return (
                <TrackButton
                  key={index + track.id}
                  track={track}
                  index={index}
                  active={currentTrack?.id === track.id && currentPlaylist?.id === params.id}
                  on={{
                    MouseButtonRelease: () => trackClickHandler(track),
                  }}
                  onTrackClick={() => {
                    handlePlaylistPlayPause(index);
                  }}
                />
              );
            }
          })}
        </View>
      </ScrollArea>
    </View>
  );
};

export interface TrackButtonProps {
  track: SpotifyApi.TrackObjectFull;
  on: Partial<QWidgetSignals | WidgetEventListeners>;
  onTrackClick?: QAbstractButtonSignals["clicked"];
  active: boolean;
  index: number;
}

export const TrackButton: FC<TrackButtonProps> = ({ track, active, index, on, onTrackClick }) => {
  const { reactToTrack, isFavorite } = useTrackReaction();

  const duration = useMemo(() => msToMinAndSec(track.duration_ms), []);
  return (
    <View
      id={active ? "active" : "track-button"}
      styleSheet={trackButtonStyle}
      on={{
        ...on,
        MouseButtonRelease(native: any) {
          if (new QMouseEvent(native).button() === 1) {
            (on as WidgetEventListeners).MouseButtonRelease();
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
        <IconButton icon={new QIcon(active ? pause : play)} on={{ clicked: onTrackClick }} />
      </View>
    </View>
  );
};

const trackButtonStyle = `
  #active{
    background-color: #34eb71;
    color: #333;
  }
  #track-button:hover, #active:hover{
    background-color: rgba(229, 224, 224, 0.48);
  }
`;

export default PlaylistView;

export function TrackTableIndex() {
  return (
    <View>
      <Text style="padding: 5px;">{`<h3>#</h3>`}</Text>
      <Text style="width: '35%';">{`<h3>Title</h3>`}</Text>
      <Text style="width: '25%';">{`<h3>Album</h3>`}</Text>
      <Text style="width: '15%';">{`<h3>Duration</h3>`}</Text>
      <Text style="width: '15%';">{`<h3>Actions</h3>`}</Text>
    </View>
  );
}
interface PlaylistSimpleControlsProps {
  handlePlaylistPlayPause: (index?: number) => void;
  handlePlaylistReact?: () => void;
  isActive: boolean;
  isFavorite?: boolean;
}

export function PlaylistSimpleControls({ handlePlaylistPlayPause, isActive, handlePlaylistReact, isFavorite }: PlaylistSimpleControlsProps) {
  return (
    <View style={`justify-content: 'space-evenly'; max-width: 150px; padding: 10px;`}>
      <BackButton />
      {isFavorite !== undefined && <IconButton icon={new QIcon(isFavorite ? heart : heartRegular)} on={{ clicked: handlePlaylistReact }} />}
      <IconButton
        style={`background-color: #00be5f; color: white;`}
        on={{
          clicked() {
            handlePlaylistPlayPause();
          },
        }}
        icon={new QIcon(isActive ? stop : play)}
      />
    </View>
  );
}
