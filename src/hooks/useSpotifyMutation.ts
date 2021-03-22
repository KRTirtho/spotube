import { useEffect } from "react";
import { useMutation, UseMutationOptions } from "react-query";
import SpotifyWebApi from "spotify-web-api-node";
import useSpotifyApi from "./useSpotifyApi";
import useSpotifyApiError from "./useSpotifyApiError";

type SpotifyMutationFn<TData = unknown, TVariables = unknown> = (spotifyApi: SpotifyWebApi, variables: TVariables) => Promise<TData>;

function useSpotifyMutation<TData = unknown, TVariable = unknown>(mutationFn: SpotifyMutationFn<TData, TVariable>, options?: UseMutationOptions<TData, SpotifyApi.ErrorObject, TVariable>) {
  const spotifyApi = useSpotifyApi();
  const handleSpotifyError = useSpotifyApiError(spotifyApi);
  const mutation = useMutation<TData, SpotifyApi.ErrorObject, TVariable>((arg) => mutationFn(spotifyApi, arg), options);
  const { isError, error } = mutation;

  useEffect(() => {
    if (isError && error) {
      handleSpotifyError(error);
    }
  }, [isError, error]);

  return mutation;
}

export default useSpotifyMutation;
