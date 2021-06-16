import chalk from "chalk";
import { useContext } from "react";
import SpotifyWebApi from "spotify-web-api-node";
import authContext from "../context/authContext";
import showError from "../helpers/showError";

function useSpotifyApiError(spotifyApi: SpotifyWebApi) {
    const { setAccess_token, isLoggedIn } = useContext(authContext);
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    return async (error: SpotifyApi.ErrorObject | any) => {
        const isUnauthorized = error.message === "Unauthorized";
        const status401 = error.status === 401;
        const bodyStatus401 = error.body.error.status === 401;
        const noToken = error.body.error.message === "No token provided";
        const expiredToken = error.body.error.message === "The access token expired";
        if (
            (isUnauthorized && isLoggedIn && status401) ||
            ((noToken || expiredToken) && bodyStatus401)
        ) {
            try {
                console.log(chalk.bgYellow.blackBright("Refreshing Access token"));
                const {
                    body: { access_token: refreshedAccessToken },
                } = await spotifyApi.refreshAccessToken();
                setAccess_token(refreshedAccessToken);
            } catch (error) {
                showError(error, "[Authorization Failure]: ");
            }
        }
    };
}

export default useSpotifyApiError;
