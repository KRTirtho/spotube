import chalk from "chalk";
import { useContext, useEffect } from "react";
import { LocalStorageKeys } from "../app";
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
  const refreshToken = localStorage.getItem(LocalStorageKeys.refresh_token);

  useEffect(() => {
    if (isLoggedIn && clientId && clientSecret && refreshToken) {
      spotifyApi.setClientId(clientId);
      spotifyApi.setClientSecret(clientSecret);
      spotifyApi.setRefreshToken(refreshToken);
      if (!access_token) {
        spotifyApi
          .refreshAccessToken()
          .then((token) => {
            setAccess_token(token.body.access_token);
          })
          .catch((error) => {
            showError(error);
          });
      }
      spotifyApi.setAccessToken(access_token);
    }
  }, [access_token, clientId, clientSecret, isLoggedIn]);

  return spotifyApi;
}

export default useSpotifyApi;
