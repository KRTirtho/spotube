import { Button, ScrollArea, View } from "@nodegui/react-nodegui";
import React, { useContext } from "react";
import { Redirect, Route } from "react-router";
import { QueryCacheKeys } from "../conf";
import playerContext from "../context/playerContext";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import { GenreView } from "./PlaylistGenreView";
import { PlaylistSimpleControls, TrackTableIndex } from "./PlaylistView";
import PlaceholderApplet from "./shared/PlaceholderApplet";
import { TrackButton, TrackButtonPlaylistObject } from "./shared/TrackButton";
import { TabMenuItem } from "./TabMenu";

function Library() {
  return (
    <View style="flex: 1; flex-direction: 'column';">
      <Redirect from="/library" to="/library/saved-tracks" />
      <View style="max-width: 350px; justify-content: 'space-evenly'">
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
  const { data: userPagedPlaylists, isError, isLoading, refetch, isFetchingNextPage, hasNextPage, fetchNextPage } = useSpotifyInfiniteQuery<SpotifyApi.ListOfUsersPlaylistsResponse>(
    QueryCacheKeys.userPlaylists,
    (spotifyApi, { pageParam }) =>
      spotifyApi.getUserPlaylists({ limit: 20, offset: pageParam }).then((userPlaylists) => {
        return userPlaylists.body;
      }),
    {
      getNextPageParam(lastPage) {
        if (lastPage.next) {
          return lastPage.offset + lastPage.limit;
        }
      },
    }
  );

  const userPlaylists = userPagedPlaylists?.pages
    ?.map((playlist) => playlist.items)
    .filter(Boolean)
    .flat(1) as SpotifyApi.PlaylistObjectSimplified[];

  return (
    <GenreView
      heading="User Playlists"
      isError={isError}
      isLoading={isLoading}
      playlists={userPlaylists ?? []}
      isLoadable={!isFetchingNextPage}
      refetch={refetch}
      loadMore={hasNextPage ? ()=>fetchNextPage() : undefined}
    />
  );
}

function UserSavedTracks() {
  const userSavedPlaylistId = "user-saved-tracks";
  const { data: userSavedTracks, fetchNextPage, hasNextPage, isFetchingNextPage, isError, isLoading, refetch } = useSpotifyInfiniteQuery<SpotifyApi.UsersSavedTracksResponse>(
    QueryCacheKeys.userSavedTracks,
    (spotifyApi, { pageParam }) => spotifyApi.getMySavedTracks({ limit: 50, offset: pageParam }).then((res) => res.body),
    {
      getNextPageParam(lastPage) {
        if (lastPage.next) {
          return lastPage.offset + lastPage.limit;
        }
      },
    }
  );
  const { currentPlaylist, setCurrentPlaylist, setCurrentTrack } = useContext(playerContext);

  const userTracks = userSavedTracks?.pages
    ?.map((page) => page.items)
    .filter(Boolean)
    .flat(1) as SpotifyApi.SavedTrackObject[] | undefined;

  function handlePlaylistPlayPause(index?: number) {
    if (currentPlaylist?.id !== userSavedPlaylistId && userTracks) {
      setCurrentPlaylist({ id: userSavedPlaylistId, name: "Liked Tracks", thumbnail: "https://nerdist.com/wp-content/uploads/2020/07/maxresdefault.jpg", tracks: userTracks });
      setCurrentTrack(userTracks[index ?? 0].track);
    } else {
      setCurrentPlaylist(undefined);
      setCurrentTrack(undefined);
    }
  }

  const playlist: TrackButtonPlaylistObject = {
    collaborative: false,
    description: "User Playlist",
    tracks: {
      items: userTracks ?? [],
      limit: 20,
      href: "",
      next: "",
      offset: 0,
      previous: "",
      total: 20,
    },
    external_urls: { spotify: "" },
    href: "",
    id: userSavedPlaylistId,
    images: [{ url: "https://facebook.com/img.jpeg" }],
    name: "User saved track",
    owner: { external_urls: { spotify: "" }, href: "", id: "Me", type: "user", uri: "spotify:user:me", display_name: "User", followers: { href: null, total: 0 } },
    public: false,
    snapshot_id: userSavedPlaylistId + "snapshot",
    type: "playlist",
    uri: "spotify:user:me:saved-tracks",
  };
  return (
    <View style="flex: 1; flex-direction: 'column';">
      <PlaylistSimpleControls handlePlaylistPlayPause={handlePlaylistPlayPause} isActive={currentPlaylist?.id === userSavedPlaylistId} />
      <TrackTableIndex />
      <ScrollArea style="flex: 1; border: none;">
        <View style="flex: 1; flex-direction: 'column'; align-items: 'stretch';">
          <PlaceholderApplet error={isError} loading={isLoading || isFetchingNextPage} message="Failed querying spotify" reload={refetch} />
          {userTracks?.map(({ track }, index) => track && <TrackButton key={index + track.id} track={track} index={index} playlist={playlist} />)}
          {hasNextPage && (
            <Button
              style="flex-grow: 0; align-self: 'center';"
              text="Load more"
              on={{
                clicked() {
                  fetchNextPage();
                },
              }}
              enabled={!isFetchingNextPage}
            />
          )}
        </View>
      </ScrollArea>
    </View>
  );
}
