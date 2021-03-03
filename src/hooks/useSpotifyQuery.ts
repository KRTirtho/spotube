import { useEffect } from "react";
import { QueryKey, useQuery, UseQueryOptions, UseQueryResult } from "react-query";
import SpotifyWebApi from "spotify-web-api-node";
import useSpotifyApi from "./useSpotifyApi";
import useSpotifyApiError from "./useSpotifyApiError";

type SpotifyQueryFn<TQueryData> = (spotifyApi: SpotifyWebApi) => Promise<TQueryData>;

function useSpotifyQuery<TQueryData = unknown>(
  queryKey: QueryKey,
  queryHandler: SpotifyQueryFn<TQueryData>,
  options: UseQueryOptions<TQueryData, SpotifyApi.ErrorObject> = {}
): UseQueryResult<TQueryData, SpotifyApi.ErrorObject> {
  const spotifyApi = useSpotifyApi();
  const handleSpotifyError = useSpotifyApiError(spotifyApi);
  const query = useQuery<TQueryData, SpotifyApi.ErrorObject>(queryKey, ()=>queryHandler(spotifyApi), options);
  const { isError, error } = query;
  
  
  useEffect(() => {
    if (isError && error) {
      handleSpotifyError(error);
    }
  }, [isError, error]);

  return query;
}

export default useSpotifyQuery;
