import { ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useContext, useEffect, useState } from "react";
import { useLocation, useParams } from "react-router";
import authContext from "../context/authContext";
import useSpotifyApi from "../hooks/useSpotifyApi";
import BackButton from "./BackButton";
import { PlaylistCard } from "./Home";

function PlaylistGenreView() {
  const { id } = useParams<{ id: string }>();
  const location = useLocation<{ name: string }>();
  const [playlists, setPlaylists] = useState<SpotifyApi.PlaylistObjectSimplified[]>([]);
  const { access_token, isLoggedIn } = useContext(authContext);
  const spotifyApi = useSpotifyApi();

  useEffect(() => {
    let mounted = true;

    (async () => {
      try {
        if (access_token) {
          const playlistsRes = await spotifyApi.getPlaylistsForCategory(id);
          mounted && setPlaylists(playlistsRes.body.playlists.items);
        }
      } catch (error) {
        console.error(`Failed to get playlists of category ${name} for: `, error);
      }
    })();
    return () => {
      mounted = false;
    };
  }, [access_token]);

  const playlistGenreViewStylesheet = `
    #genre-container{
      flex-direction: column;
      flex: 1;
    }
    #heading {
      padding: 10px;
    }
    #scroll-view{
      flex: 1;
      flex-grow: 1;
      border: none;
    }
    #child-container {
      flex-direction: "row";
      justify-content: "space-evenly";
      align-items: 'center';
      flex-wrap: "wrap";
      width: 330px;
    }
  `;

  return (
    <View id="genre-container" styleSheet={playlistGenreViewStylesheet}>
      <BackButton />
      <Text id="heading">{`<h2>${location.state.name}</h2>`}</Text>
      <ScrollArea id="scroll-view">
        <View id="child-container">
          {isLoggedIn &&
            playlists.map((playlist, index) => {
              return <PlaylistCard key={((index * Date.now()) / Math.random()) * 100} id={playlist.id} name={playlist.name} thumbnail={playlist.images[0].url} />;
            })}
        </View>
      </ScrollArea>
    </View>
  );
}

export default PlaylistGenreView;
