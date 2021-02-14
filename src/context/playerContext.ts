import React, { Dispatch, SetStateAction } from "react";
import SpotifyWebApi from "spotify-web-api-node";

export type CurrentTrack = SpotifyApi.TrackObjectFull;

export type CurrentPlaylist = { tracks: SpotifyApi.PlaylistTrackObject[]; id: string; name: string; thumbnail: string };

export interface PlayerContext {
  spotifyApi: SpotifyWebApi;
  currentPlaylist?: CurrentPlaylist;
  currentTrack?: CurrentTrack;
  setCurrentPlaylist: Dispatch<SetStateAction<CurrentPlaylist | undefined>>;
  setCurrentTrack: Dispatch<SetStateAction<CurrentTrack | undefined>>;
}

const playerContext = React.createContext<PlayerContext>({ spotifyApi: new SpotifyWebApi(), setCurrentPlaylist() {}, setCurrentTrack() {} });

export default playerContext;
