import { DependencyList, useContext, useEffect } from "react";
import authContext from "../context/authContext";
import { CredentialKeys } from "../app";
import playerContext from "../context/playerContext";

interface UseAuthResult {
  access_token: string;
}

export default (deps: DependencyList = []): UseAuthResult => {
  const { access_token, expires_in, isLoggedIn, setExpiresIn, setAccess_token } = useContext(authContext);
  const { spotifyApi } = useContext(playerContext);
  const refreshToken = localStorage.getItem(CredentialKeys.refresh_token);

  useEffect(() => {
    const isExpiredToken = Date.now() > expires_in;
    if (isLoggedIn && isExpiredToken && refreshToken) {
      spotifyApi.setRefreshToken(refreshToken);
      spotifyApi
        .refreshAccessToken()
        .then(({ body: { access_token, expires_in } }) => {
          setAccess_token(access_token);
          setExpiresIn(Date.now() + expires_in);
        })
        .catch();
    }
  }, deps);

  return { access_token };
};
