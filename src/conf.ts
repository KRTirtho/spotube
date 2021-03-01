import dotenv from "dotenv"
import { join } from "path";

const env = dotenv.config({path: join(process.cwd(), ".env")}).parsed as any
export const clientId = "";
export const trace = process.argv.find(arg => arg === "--trace") ?? false;
export const redirectURI = "http://localhost:4304/auth/spotify/callback"

export enum QueryCacheKeys{
  categories="categories",
  categoryPlaylists = "categoryPlaylists",
  playlistTracks="playlistTracks"
}