import React, { useContext, useMemo, useState } from "react";
import { Button, ScrollArea, View, Text } from "@nodegui/react-nodegui";
import { useHistory } from "react-router";
import CachedImage from "./shared/CachedImage";
import { CursorShape, QIcon, QMouseEvent } from "@nodegui/nodegui";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import ErrorApplet from "./shared/ErrorApplet";
import IconButton from "./shared/IconButton";
import { heart, heartRegular, pause, play } from "../icons";
import playerContext from "../context/playerContext";
import { audioPlayer } from "./Player";
import showError from "../helpers/showError";
import { generateRandomColor, getDarkenForeground } from "../helpers/RandomColor";
import usePlaylistReaction from "../hooks/usePlaylistReaction";

function Home() {
  const { data: categories, isError, isRefetchError, refetch } = useSpotifyQuery<SpotifyApi.CategoryObject[]>(
    QueryCacheKeys.categories,
    (spotifyApi) => spotifyApi.getCategories({ country: "US" }).then((categoriesReceived) => categoriesReceived.body.categories.items),
    { initialData: [] }
  );

  return (
    <ScrollArea style={`flex-grow: 1; border: none; flex: 1;`}>
      <View style={`flex-direction: 'column'; justify-content: 'center'; flex: 1;`}>
        {(isError || isRefetchError) && <ErrorApplet message="Failed to query genres" reload={refetch} helps />}
        {categories?.map((category, index) => {
          return <CategoryCard key={index + category.id} id={category.id} name={category.name} />;
        })}
      </View>
    </ScrollArea>
  );
}

export default Home;

interface CategoryCardProps {
  id: string;
  name: string;
}

const categoryStylesheet = `
     #container{
       flex: 1;
       flex-direction: column;
       justify-content: 'center';
       margin-bottom: 20px;
     }
     #anchor-heading{
       background: transparent;
       padding: 10px;
       border: none;
       outline: none;
       font-size: 20px;
       font-weight: bold;
       align-self: flex-start;
     }
     #child-view{
        flex: 1;
        justify-content: 'space-around';
        align-items: 'center';
      }
     #anchor-heading:hover{
       border: none;
       outline: none;
       text-decoration: underline;
     }
  `;
const CategoryCard = ({ id, name }: CategoryCardProps) => {
  const history = useHistory();
  const { data: playlists, isError } = useSpotifyQuery<SpotifyApi.PlaylistObjectSimplified[]>(
    [QueryCacheKeys.categoryPlaylists, id],
    (spotifyApi) => spotifyApi.getPlaylistsForCategory(id, { limit: 4 }).then((playlistsRes) => playlistsRes.body.playlists.items),
    { initialData: [] }
  );

  function goToGenre() {
    history.push(`/genre/playlists/${id}`, { name });
  }
  if (isError) {
    return <></>;
  }
  return (
    <View id="container" styleSheet={categoryStylesheet}>
      <Button id="anchor-heading" cursor={CursorShape.PointingHandCursor} on={{ MouseButtonRelease: goToGenre }} text={name} />
      <View id="child-view">
        {playlists?.map((playlist, index) => {
          return <PlaylistCard key={index + playlist.id} playlist={playlist} />;
        })}
      </View>
    </View>
  );
};

interface PlaylistCardProps {
  playlist: SpotifyApi.PlaylistObjectSimplified;
}

export const PlaylistCard = React.memo(({ playlist }: PlaylistCardProps) => {
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
      padding: 5px;
      min-height: 150px;
      background-color: ${bgColor1};
      border-radius: 5px;
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
});
