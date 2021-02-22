import { useContext, useEffect } from "react";
import authContext from "../context/authContext";
import spotifyApi from "../initializations/spotifyApi";
import useAccessToken from "./useAccessToken";

function useSpotifyApi() {
  const { isLoggedIn, clientId, clientSecret } = useContext(authContext);
  const { access_token } = useAccessToken(spotifyApi, [clientId, clientSecret]);

  useEffect(() => {
    if (isLoggedIn && clientId && clientSecret) {
      spotifyApi.setClientId(clientId);
      spotifyApi.setClientSecret(clientSecret);
      spotifyApi.setAccessToken(access_token);
    }
  }, [access_token, clientId, clientSecret]);

  return spotifyApi;
}

export default useSpotifyApi;