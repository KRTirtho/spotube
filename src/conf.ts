import dotenv from "dotenv"
import { homedir } from "os";
import { join } from "path";

const env = dotenv.config({path: join(process.cwd(), ".env")}).parsed as any
export const clientId = "";
export const trace = process.argv.find(arg => arg === "--trace") ?? false;
export const redirectURI = "http://localhost:4304/auth/spotify/callback"
export const confDir = join(homedir(), ".config", "spotube")
export const cacheDir = join(homedir(), ".cache", "spotube")

export enum QueryCacheKeys{
  categories="categories",
  categoryPlaylists = "categoryPlaylists",
  genrePlaylists="genrePlaylists",
  playlistTracks="playlistTracks",
  userPlaylists = "user-palylists",
  userSavedTracks = "user-saved-tracks",
  search = "search",
  searchPlaylist = "searchPlaylist",
  searchSongs = "searchSongs"
}