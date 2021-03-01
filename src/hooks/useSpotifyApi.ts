import chalk from "chalk";
import { useContext, useEffect } from "react";
import { CredentialKeys } from "../app";
import authContext from "../context/authContext";
import spotifyApi from "../initializations/spotifyApi";

function useSpotifyApi() {
  const { access_token, clientId, clientSecret, isLoggedIn } = useContext(authContext);
  const refreshToken = localStorage.getItem(CredentialKeys.refresh_token);

  useEffect(() => {
    if (isLoggedIn && clientId && clientSecret && refreshToken) {
      console.log(chalk.bgCyan.black("Setting up spotify credentials"))
      spotifyApi.setClientId(clientId);
      spotifyApi.setClientSecret(clientSecret);
      spotifyApi.setRefreshToken(refreshToken);
      spotifyApi.setAccessToken(access_token);
    }
  }, [access_token, clientId, clientSecret, isLoggedIn]);

  return spotifyApi;
}

export default useSpotifyApi;
