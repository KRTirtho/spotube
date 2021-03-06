import { ScrollArea, View } from "@nodegui/react-nodegui";
import React, { useContext } from "react";
import { Redirect, Route } from "react-router";
import { QueryCacheKeys } from "../conf";
import playerContext from "../context/playerContext";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import { PlaylistCard } from "./Home";
import { PlaylistSimpleControls, TrackButton } from "./PlaylistView";
import { TabMenuItem } from "./TabMenu";

function Library() {
  return (
    <View style="flex: 1; flex-direction: 'row';">
      <Redirect from="/library" to="/library/saved-tracks" />
      <View style="flex-direction: 'column'; flex: 1; max-width: 150px;">
        <TabMenuItem title="Saved Tracks" url="/library/saved-tracks" />
        <TabMenuItem title="Playlists" url="/library/playlists" />
      </View>
      <Route exact path="/library/saved-tracks">
        <UserSavedTracks />
      </Route>
      <Route exact path="/library/playlists">
        <UserPlaylists />
      </Route>
    </View>
  );
}

export default Library;

function UserPlaylists() {
  const { data: userPlaylists, isError, isLoading, refetch } = useSpotifyQuery<SpotifyApi.PlaylistObjectSimplified[]>(QueryCacheKeys.userPlaylists, (spotifyApi) =>
    spotifyApi.getUserPlaylists().then((userPlaylists) => {
      return userPlaylists.body.items;
    })
  );

  return (
    <ScrollArea style="flex: 1; border: none;">
      <View style="flex: 1; flex-direction: 'row'; flex-wrap: 'wrap'; justify-content: 'space-evenly'; width: 330px; align-items: 'center';">
        {userPlaylists?.map((playlist, index) => (
          <PlaylistCard key={index + playlist.id} id={playlist.id} name={playlist.name} thumbnail={playlist.images[0].url} />
        ))}
      </View>
    </ScrollArea>
  );
}

function UserSavedTracks() {
  const userSavedPlaylistId = "user-saved-tracks";
  const { data: userTracks, isError, isLoading } = useSpotifyQuery<SpotifyApi.SavedTrackObject[]>(QueryCacheKeys.userSavedTracks, (spotifyApi) =>
    spotifyApi.getMySavedTracks({ limit: 50 }).then((tracks) => tracks.body.items)
  );
  const { currentPlaylist, setCurrentPlaylist, setCurrentTrack, currentTrack } = useContext(playerContext);

  function handlePlaylistPlayPause() {
    if (currentPlaylist?.id !== userSavedPlaylistId && userTracks) {
      setCurrentPlaylist({ id: userSavedPlaylistId, name: "Liked Tracks", thumbnail: "https://nerdist.com/wp-content/uploads/2020/07/maxresdefault.jpg", tracks: userTracks });
      setCurrentTrack(userTracks[0].track);
    } else {
      setCurrentPlaylist(undefined);
      setCurrentTrack(undefined);
    }
  }

  return (
    <View style="flex: 1; flex-direction: 'column';">
      <PlaylistSimpleControls handlePlaylistPlayPause={handlePlaylistPlayPause} isActive={currentPlaylist?.id === userSavedPlaylistId} />
      <ScrollArea style="flex: 1; border: none;">
        <View style="flex: 1; flex-direction: 'column'; align-items: 'stretch';">
          {userTracks?.map(({ track }, index) => (
            <TrackButton
              key={index+track.id}
              active={currentPlaylist?.id === userSavedPlaylistId && currentTrack?.id === track.id}
              artist={track.artists.map((x) => x.name).join(", ")}
              name={track.name}
              on={{
                clicked() {
                  setCurrentTrack(track);
                },
              }}
            />
          ))}
        </View>
      </ScrollArea>
    </View>
  );
}
