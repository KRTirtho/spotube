import { useContext, useEffect } from "react";
import { CredentialKeys } from "../app";
import authContext from "../context/authContext";
import spotifyApi from "../initializations/spotifyApi";

function useSpotifyApi() {
  const { access_token, clientId, clientSecret, expires_in, isLoggedIn, setExpires_in, setAccess_token } = useContext(authContext);
  const refreshToken = localStorage.getItem(CredentialKeys.refresh_token);

  useEffect(() => {
    if (isLoggedIn && clientId && clientSecret) {
      spotifyApi.setClientId(clientId);
      spotifyApi.setClientSecret(clientSecret);
      spotifyApi.setAccessToken(access_token);
    }
    const isExpiredToken = Date.now() > expires_in;
    if (isLoggedIn && isExpiredToken && refreshToken) {
      spotifyApi.setRefreshToken(refreshToken);
      spotifyApi
        .refreshAccessToken()
        .then(({ body: { access_token, expires_in } }) => {
          setAccess_token(access_token);
          setExpires_in(expires_in);
        })
        .catch();
    }
  }, [access_token, clientId, clientSecret]);

  return spotifyApi;
}

export default useSpotifyApi;
