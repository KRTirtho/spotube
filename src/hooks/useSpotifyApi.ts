import chalk from "chalk";
import { useContext, useEffect } from "react";
import { CredentialKeys } from "../app";
import authContext from "../context/authContext";
import showError from "../helpers/showError";
import spotifyApi from "../initializations/spotifyApi";

function useSpotifyApi() {
  const {
    access_token,
    clientId,
    clientSecret,
    isLoggedIn,
    setAccess_token,
  } = useContext(authContext);
  const refreshToken = localStorage.getItem(CredentialKeys.refresh_token);

  useEffect(() => {
    if (isLoggedIn && clientId && clientSecret && refreshToken) {
      console.log(chalk.bgCyan.black("Setting up spotify credentials"));
      spotifyApi.setClientId(clientId);
      spotifyApi.setClientSecret(clientSecret);
      spotifyApi.setRefreshToken(refreshToken);
      if (!access_token) {
        spotifyApi
          .refreshAccessToken()
          .then((token) => {
            console.log(chalk.bgRedBright.yellow("Refreshing access token from useSpotifyApi"));
            setAccess_token(token.body.access_token);
          })
          .catch((error) => {
            showError(error);
          });
      }
      spotifyApi.setAccessToken(access_token);
      console.log(chalk.bgCyan.green("Finished setting up credentials"));
    }
  }, [access_token, clientId, clientSecret, isLoggedIn]);

  return spotifyApi;
}

export default useSpotifyApi;
