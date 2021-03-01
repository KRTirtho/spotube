import React, { useContext, useEffect, useState } from "react";
import { Button, ScrollArea, BoxView } from "@nodegui/react-nodegui";
import { useHistory } from "react-router";
import CachedImage from "./shared/CachedImage";
import { CursorShape, Direction } from "@nodegui/nodegui";
import useSpotifyApi from "../hooks/useSpotifyApi";
import showError from "../helpers/showError";
import authContext from "../context/authContext";
import useSpotifyApiError from "../hooks/useSpotifyApiError";

function Home() {
  const spotifyApi = useSpotifyApi();
  const { access_token } = useContext(authContext);
  const [categories, setCategories] = useState<SpotifyApi.CategoryObject[]>([]);
  const handleSpotifyError = useSpotifyApiError(spotifyApi);

  useEffect(() => {
    if (categories.length === 0) {
      spotifyApi
        .getCategories({ country: "US" })
        .then((categoriesReceived) => setCategories(categoriesReceived.body.categories.items))
        .catch((error) => {
          showError(error, "[Spotify genre loading failed]: ");
          handleSpotifyError(error);
        });
    }
  }, [access_token]);

  return (
    <ScrollArea style={`flex-grow: 1; border: none;`}>
      <BoxView direction={Direction.TopToBottom}>
        {categories.map((category, index) => {
          return <CategoryCard key={index+category.id} id={category.id} name={category.name} />;
        })}
      </BoxView>
    </ScrollArea>
  );
}

export default Home;

interface CategoryCardProps {
  id: string;
  name: string;
}

const CategoryCard = ({ id, name }: CategoryCardProps) => {
  const history = useHistory();
  const [playlists, setPlaylists] = useState<SpotifyApi.PlaylistObjectSimplified[]>([]);
  const spotifyApi = useSpotifyApi();
  const handleSpotifyError = useSpotifyApiError(spotifyApi);

  useEffect(() => {
    if (playlists.length === 0) {
      spotifyApi
        .getPlaylistsForCategory(id, { limit: 4 })
        .then((playlistsRes) => setPlaylists(playlistsRes.body.playlists.items))
        .catch((error) => {
          showError(error, `[Failed to get playlists of category ${name}]: `);
          handleSpotifyError(error);
        });
    }
  }, []);

  function goToGenre() {
    history.push(`/genre/playlists/${id}`, { name });
  }

  return (
    <BoxView id="container" styleSheet={categoryStylesheet} direction={Direction.TopToBottom}>
      <Button id="anchor-heading" cursor={CursorShape.PointingHandCursor} on={{ MouseButtonRelease: goToGenre }} text={name} />
      <BoxView direction={Direction.LeftToRight}>
        {playlists.map((playlist, index) => {
          return <PlaylistCard key={index+playlist.id} id={playlist.id} name={playlist.name} thumbnail={playlist.images[0].url} />;
        })}
      </BoxView>
    </BoxView>
  );
};

const categoryStylesheet = `
     #container{
       margin-bottom: 20px;
     }
     #anchor-heading{
       background: transparent;
       padding: 10px;
       border: none;
       outline: none;
       font-size: 20px;
       font-weight: bold;
       text-align: left;
     }
     #anchor-heading:hover{
       border: none;
       outline: none;
       text-decoration: underline;
     }
  `;

interface PlaylistCardProps {
  thumbnail: string;
  name: string;
  id: string;
}

export const PlaylistCard = React.memo(({ id, name, thumbnail }: PlaylistCardProps) => {
  const history = useHistory();

  function gotoPlaylist() {
    history.push(`/playlist/${id}`, { name, thumbnail });
  }

  const playlistStyleSheet = `
    #playlist-container{
      max-width: 150px;
      max-height: 150px;
      min-height: 150px;
    }
    #playlist-container:hover{
      border: 1px solid green;
    }
    #playlist-container:clicked{
      border: 5px solid green;
    }
  `;

  return (
    <BoxView size={{height: 150, width: 150, fixed: true}} direction={Direction.TopToBottom} id="playlist-container" cursor={CursorShape.PointingHandCursor} styleSheet={playlistStyleSheet} on={{ MouseButtonRelease: gotoPlaylist }}>
      <CachedImage src={thumbnail} maxSize={{ height: 150, width: 150 }} scaledContents alt={name} />
    </BoxView>
  );
});
