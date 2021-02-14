import React, { useContext, useEffect, useState } from "react";
import { Button, View, ScrollArea } from "@nodegui/react-nodegui";
import playerContext from "../context/playerContext";
import authContext from "../context/authContext";
import { useHistory } from "react-router";
import CachedImage from "./shared/CachedImage";
import { CursorShape } from "@nodegui/nodegui";

function Home() {
  const { spotifyApi } = useContext(playerContext);
  const { isLoggedIn, access_token } = useContext(authContext);
  const [categories, setCategories] = useState<SpotifyApi.CategoryObject[]>([]);

  useEffect(() => {
    (async () => {
      try {
        if (access_token) {
          spotifyApi.setAccessToken(access_token);
          const categoriesReceived = await spotifyApi.getCategories({ country: "US" });
          setCategories(categoriesReceived.body.categories.items);
        }
      } catch (error) {
        console.error("Spotify featured playlist loading failed: ", error);
      }
    })();
  }, [access_token]);

  return (
    <ScrollArea style={`flex-grow: 1; border: none; flex: 1;`}>
      <View style={`flex-direction: 'column'; justify-content: 'center'; flex: 1;`}>
        <CategoryCard key={((Math.random() * Date.now()) / Math.random()) * 100} id="current" name="Currently Playing" />
        {isLoggedIn &&
          categories.map(({ id, name }, index) => {
            return <CategoryCard key={((index * Date.now()) / Math.random()) * 100} id={id} name={name} />;
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

function CategoryCard({ id, name }: CategoryCardProps) {
  const history = useHistory();
  const [playlists, setPlaylists] = useState<SpotifyApi.PlaylistObjectSimplified[]>([]);
  const { access_token, isLoggedIn } = useContext(authContext);
  const { spotifyApi, currentPlaylist } = useContext(playerContext);

  useEffect(() => {
    (async () => {
      try {
        if (access_token) {
          if (id === "current") {
          } else {
            spotifyApi.setAccessToken(access_token);

            const playlistsRes = await spotifyApi.getPlaylistsForCategory(id, { limit: 5 });
            setPlaylists(playlistsRes.body.playlists.items);
          }
        }
      } catch (error) {
        console.error(`Failed to get playlists of category ${name} for: `, error);
      }
    })();
  }, [access_token]);

  function goToGenre() {
    history.push(`/genre/playlists/${id}`, { name });
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
       align-self: 'flex-start';
     }
     #anchor-heading:hover{
       border: none;
       outline: none;
       text-decoration: underline;
     }
     #child-view{
       flex: 1;
       justify-content: 'space-evenly';
       align-items: 'center';
       flex-wrap: 'wrap';
     }
  `;

  if (playlists.length > 0 && id!=="current") {
    return (
      <View id="container" styleSheet={categoryStylesheet}>
        <Button id="anchor-heading" cursor={CursorShape.PointingHandCursor} on={{ MouseButtonRelease: goToGenre }} text={name} />
        <View id="child-view">
          {isLoggedIn &&
            playlists.map((playlist, index) => {
              return <PlaylistCard key={((index * Date.now()) / Math.random()) * 100} id={playlist.id} name={playlist.name} thumbnail={playlist.images[0].url} />;
            })}
        </View>
      </View>
    );
  }
  if (id === "current" && currentPlaylist) {
    return (
      <View id="container" styleSheet={categoryStylesheet}>
        <Button id="anchor-heading" cursor={CursorShape.PointingHandCursor} on={{ MouseButtonRelease: goToGenre }} text={name} />
        <View id="child-view">
          <PlaylistCard key={(Date.now() / Math.random()) * 100} {...currentPlaylist} />
        </View>
      </View>
    );
  }
  return <></>;
}

interface PlaylistCardProps {
  thumbnail: string;
  name: string;
  id: string;
}

export function PlaylistCard({ id, name, thumbnail }: PlaylistCardProps) {
  const history = useHistory();

  function gotoPlaylist() {
    history.push(`/playlist/${id}`, { name, thumbnail });
  }

  const playlistStyleSheet = `
    #playlist-container{
      max-width: 250px;
      flex-direction: column;
      padding: 2px;
    }
    #playlist-container:hover{
      border: 1px solid green;
    }
    #playlist-container:clicked{
      border: 5px solid green;
    }
  `;

  return (
    <View id="playlist-container" cursor={CursorShape.PointingHandCursor} styleSheet={playlistStyleSheet} on={{ MouseButtonRelease: gotoPlaylist }}>
      <CachedImage src={thumbnail} maxSize={{ height: 150, width: 150 }} scaledContents alt={name} />
    </View>
  );
}
