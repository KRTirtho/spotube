import { DependencyList, useContext, useEffect } from "react";
import authContext from "../context/authContext";
import { CredentialKeys } from "../app";
import SpotifyWebApi from "spotify-web-api-node";

interface UseAccessTokenResult {
  access_token: string;
}

export default (spotifyApi: SpotifyWebApi, deps: DependencyList = []): UseAccessTokenResult => {
  const { access_token, expires_in, isLoggedIn, setExpires_in, setAccess_token } = useContext(authContext);
  const refreshToken = localStorage.getItem(CredentialKeys.refresh_token);

  useEffect(() => {
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
  }, deps);

  return { access_token };
};
