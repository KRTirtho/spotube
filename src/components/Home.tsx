import React from "react";
import { Button, ScrollArea, BoxView, View } from "@nodegui/react-nodegui";
import { useHistory } from "react-router";
import CachedImage from "./shared/CachedImage";
import { CursorShape, Direction } from "@nodegui/nodegui";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import ErrorApplet from "./shared/ErrorApplet";

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
          return <PlaylistCard key={index + playlist.id} id={playlist.id} name={playlist.name} thumbnail={playlist.images[0].url} />;
        })}
      </View>
    </View>
  );
};

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
});
