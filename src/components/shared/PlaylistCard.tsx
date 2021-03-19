import { CursorShape, QIcon, QMouseEvent } from '@nodegui/nodegui';
import { Text, View } from '@nodegui/react-nodegui';
import React, { useContext, useMemo, useState } from 'react'
import { useHistory } from 'react-router';
import { QueryCacheKeys } from '../../conf';
import playerContext from '../../context/playerContext';
import { generateRandomColor, getDarkenForeground } from '../../helpers/RandomColor';
import showError from '../../helpers/showError';
import usePlaylistReaction from '../../hooks/usePlaylistReaction';
import useSpotifyQuery from '../../hooks/useSpotifyQuery';
import { heart, heartRegular, pause, play } from '../../icons';
import { audioPlayer } from '../Player';
import IconButton from './IconButton';

interface PlaylistCardProps {
  playlist: SpotifyApi.PlaylistObjectSimplified;
}

const PlaylistCard = ({ playlist }: PlaylistCardProps) => {
  const { id, description, name, images } = playlist;
  const history = useHistory();
  const [hovered, setHovered] = useState(false);
  const { setCurrentTrack, currentPlaylist, setCurrentPlaylist } = useContext(playerContext);
  const { refetch } = useSpotifyQuery<SpotifyApi.PlaylistTrackObject[]>([QueryCacheKeys.playlistTracks, id], (spotifyApi) => spotifyApi.getPlaylistTracks(id).then((track) => track.body.items), {
    initialData: [],
    enabled: false,
  });
  const { reactToPlaylist, isFavorite } = usePlaylistReaction();

  const handlePlaylistPlayPause = async () => {
    try {
      const { data: tracks, isSuccess } = await refetch();
      if (currentPlaylist?.id !== id && isSuccess && tracks) {
        setCurrentPlaylist({ tracks, id, name, thumbnail: images[0].url });
        setCurrentTrack(tracks[0].track);
      } else {
        await audioPlayer.stop();
        setCurrentTrack(undefined);
        setCurrentPlaylist(undefined);
      }
    } catch (error) {
      showError(error, "[Failed adding playlist to queue]: ");
    }
  };

  function gotoPlaylist(native?: any) {
    const key = new QMouseEvent(native);
    if (key.button() === 1) {
      history.push(`/playlist/${id}`, { name, thumbnail: images[0].url });
    }
  }

  const bgColor1 = useMemo(() => generateRandomColor(), []);
  const color = useMemo(() => getDarkenForeground(bgColor1), [bgColor1]);

  const playlistStyleSheet = `
    #playlist-container{
      width: 150px;
      flex-direction: column;
      padding: 10px;
      min-height: 150px;
      background-color: ${bgColor1};
      border-radius: 5px;
      margin: 5px;
    }
    #playlist-container:hover{
      border: 1px solid green;
    }
    #playlist-container:clicked{
      border: 5px solid green;
    }
  `;

  return (
    <View
      id="playlist-container"
      cursor={CursorShape.PointingHandCursor}
      styleSheet={playlistStyleSheet}
      on={{
        MouseButtonRelease: gotoPlaylist,
        HoverEnter() {
          setHovered(true);
        },
        HoverLeave() {
          setHovered(false);
        },
      }}>
      {/* <CachedImage src={thumbnail} maxSize={{ height: 150, width: 150 }} scaledContents alt={name} /> */}
      <Text style={`color: ${color};`} wordWrap on={{ MouseButtonRelease: gotoPlaylist }}>
        {`
          <center>
            <h3>${name}</h3>
            <p>${description}</p>
          </center>
        `}
      </Text>
      {(hovered || currentPlaylist?.id === id) && (
        <>
          <IconButton
            style={`position: absolute; bottom: 30px; left: '55%'; background-color: ${color};`}
            icon={new QIcon(isFavorite(id) ? heart : heartRegular)}
            on={{
              clicked() {
                reactToPlaylist(playlist);
              },
            }}
          />
          <IconButton
            icon={new QIcon(currentPlaylist?.id === id ? pause : play)}
            style={`position: absolute; bottom: 30px; left: '80%'; background-color: ${color};`}
            on={{
              clicked() {
                handlePlaylistPlayPause();
              },
            }}
          />
        </>
      )}
    </View>
  );
};

export default PlaylistCard;