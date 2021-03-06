import React, { Dispatch, SetStateAction } from "react";

export type CurrentTrack = SpotifyApi.TrackObjectFull;

export type CurrentPlaylist = { tracks: (SpotifyApi.PlaylistTrackObject | SpotifyApi.SavedTrackObject)[]; id: string; name: string; thumbnail: string };

export interface PlayerContext {
  currentPlaylist?: CurrentPlaylist;
  currentTrack?: CurrentTrack;
  setCurrentPlaylist: Dispatch<SetStateAction<CurrentPlaylist | undefined>>;
  setCurrentTrack: Dispatch<SetStateAction<CurrentTrack | undefined>>;
}

const playerContext = React.createContext<PlayerContext>({ setCurrentPlaylist() {}, setCurrentTrack() {} });

export default playerContext;
