import SpotifyWebApi from "spotify-web-api-node";
import { redirectURI } from "../conf";

const spotifyApi = new SpotifyWebApi({ redirectUri: redirectURI });

export default spotifyApi;