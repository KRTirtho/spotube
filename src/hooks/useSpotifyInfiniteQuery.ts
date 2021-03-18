import { useEffect } from "react";
import { QueryFunctionContext, QueryKey, useInfiniteQuery, UseInfiniteQueryOptions, UseInfiniteQueryResult } from "react-query";
import SpotifyWebApi from "spotify-web-api-node";
import useSpotifyApi from "./useSpotifyApi";
import useSpotifyApiError from "./useSpotifyApiError";

type SpotifyQueryFn<TQueryData> = (spotifyApi: SpotifyWebApi, pageArgs: QueryFunctionContext) => Promise<TQueryData>;

function useSpotifyInfiniteQuery<TQueryData = unknown>(
  queryKey: QueryKey,
  queryHandler: SpotifyQueryFn<TQueryData>,
  options: UseInfiniteQueryOptions<TQueryData, SpotifyApi.ErrorObject> = {}
): UseInfiniteQueryResult<TQueryData, SpotifyApi.ErrorObject> {
  const spotifyApi = useSpotifyApi();
  const handleSpotifyError = useSpotifyApiError(spotifyApi);
  const query = useInfiniteQuery<TQueryData, SpotifyApi.ErrorObject>(queryKey, (pageArgs) => queryHandler(spotifyApi, pageArgs), options);
  const { isError, error } = query;

  useEffect(() => {
    if (isError && error) {
      handleSpotifyError(error);
    }
  }, [isError, error]);

  return query;
}

export default useSpotifyInfiniteQuery;
