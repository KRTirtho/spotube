import chalk from "chalk";
import { useContext } from "react";
import SpotifyWebApi from "spotify-web-api-node";
import authContext from "../context/authContext";
import showError from "../helpers/showError";

function useSpotifyApiError(spotifyApi: SpotifyWebApi) {
  const { setAccess_token, isLoggedIn } = useContext(authContext);
  return async (error: any | Error | TypeError) => {
    if ((error.message === "Unauthorized" && error.status === 401 && isLoggedIn) || (error.body.error.message === "No token provided" && error.body.error.status===401)) {
      try {
        console.log(chalk.bgYellow.blackBright("Refreshing Access token"))
        const { body:{access_token: refreshedAccessToken}} = await spotifyApi.refreshAccessToken();
        setAccess_token(refreshedAccessToken);
      } catch (error) {
        showError(error, "[Authorization Failure]: ")
      }
    }
  };
}


export default useSpotifyApiError;