import React, { useState, useEffect, useRef } from "react";
import { Window, hot, View } from "@nodegui/react-nodegui";
import {
    QIcon,
    QMainWindow,
    WidgetEventTypes,
    WindowState,
    QShortcut,
    QKeySequence,
} from "@nodegui/nodegui";
import { MemoryRouter } from "react-router";
import Routes from "./routes";
import { LocalStorage } from "node-localstorage";
import authContext from "./context/authContext";
import playerContext, { CurrentPlaylist, CurrentTrack } from "./context/playerContext";
import Player, { audioPlayer } from "./components/Player";
import { QueryClient, QueryClientProvider } from "react-query";
import express from "express";
import open from "open";
import spotifyApi from "./initializations/spotifyApi";
import showError from "./helpers/showError";
import fs from "fs";
import path from "path";
import { confDir, LocalStorageKeys } from "./conf";
import spotubeIcon from "../assets/icon.svg";
import preferencesContext, {
    PreferencesContextProperties,
} from "./context/preferencesContext";

export interface Credentials {
    clientId: string;
    clientSecret: string;
}

const minSize = { width: 700, height: 750 };
const winIcon = new QIcon(spotubeIcon);
const localStorageDir = path.join(confDir, "local");
fs.mkdirSync(localStorageDir, { recursive: true });
global.localStorage = new LocalStorage(localStorageDir);
const queryClient = new QueryClient({
    defaultOptions: {
        queries: {
            onError(error) {
                showError(error);
            },
        },
    },
});

const initialPreferences: PreferencesContextProperties = {
    playlistImages: false,
};
const initialCredentials: Credentials = { clientId: "", clientSecret: "" };

//* Application start
function RootApp() {
    const windowRef = useRef<QMainWindow>();
    const [currentTrack, setCurrentTrack] = useState<CurrentTrack>();
    // cache
    const cachedPreferences = localStorage.getItem(LocalStorageKeys.preferences);
    const cachedCredentials = localStorage.getItem(LocalStorageKeys.credentials);
    // state
    const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);

    const [credentials, setCredentials] = useState<Credentials>(() => {
        if (cachedCredentials) {
            return JSON.parse(cachedCredentials);
        }
        return initialCredentials;
    });
    const [preferences, setPreferences] = useState<PreferencesContextProperties>(() => {
        if (cachedPreferences) {
            return JSON.parse(cachedPreferences);
        }
        return initialPreferences;
    });
    const [access_token, setAccess_token] = useState<string>("");
    const [currentPlaylist, setCurrentPlaylist] = useState<CurrentPlaylist>();

    useEffect(() => {
        const parsedCredentials: Credentials = JSON.parse(cachedCredentials ?? "{}");
        setIsLoggedIn(!!(parsedCredentials.clientId && parsedCredentials.clientSecret));
    }, []);

    // for user code login
    useEffect(() => {
        // saving changed credentials to storage
        localStorage.setItem(LocalStorageKeys.credentials, JSON.stringify(credentials));
        if (
            credentials.clientId &&
            credentials.clientSecret &&
            !localStorage.getItem(LocalStorageKeys.refresh_token)
        ) {
            const app = express();
            app.use(express.json());

            app.get<null, null, null, { code: string }>(
                "/auth/spotify/callback",
                async (req, res) => {
                    try {
                        spotifyApi.setClientId(credentials.clientId);
                        spotifyApi.setClientSecret(credentials.clientSecret);
                        const { body: authRes } = await spotifyApi.authorizationCodeGrant(
                            req.query.code,
                        );
                        setAccess_token(authRes.access_token);
                        localStorage.setItem(
                            LocalStorageKeys.refresh_token,
                            authRes.refresh_token,
                        );
                        setIsLoggedIn(true);
                        return res.end();
                    } catch (error) {
                        console.error("Failed to fullfil code grant flow: ", error);
                    }
                },
            );

            const server = app.listen(4304, () => {
                console.log("Server is running");
                spotifyApi.setClientId(credentials.clientId);
                spotifyApi.setClientSecret(credentials.clientSecret);
                open(
                    spotifyApi.createAuthorizeURL(
                        [
                            "user-library-read",
                            "playlist-read-private",
                            "user-library-modify",
                            "playlist-modify-private",
                            "playlist-modify-public",
                        ],
                        "xxxyyysssddd",
                    ),
                ).catch((e) =>
                    console.error("Opening IPC connection with browser failed: ", e),
                );
            });
            return () => {
                server.close(() => console.log("Closed server"));
            };
        }
    }, [credentials]);

    // just saves the preferences
    useEffect(() => {
        localStorage.setItem(LocalStorageKeys.preferences, JSON.stringify(preferences));
    }, [preferences]);

    // window event listeners
    useEffect(() => {
        const onWindowClose = () => {
            if (audioPlayer.isRunning()) {
                audioPlayer
                    .stop()
                    .catch((e) => console.error("Failed to quit MPV player: ", e));
            }
        };

        windowRef.current?.addEventListener(WidgetEventTypes.Close, onWindowClose);

        return () => {
            windowRef.current?.removeEventListener(WidgetEventTypes.Close, onWindowClose);
        };
    });
    let spaceShortcut: QShortcut | null;
    let rightShortcut: QShortcut | null;
    let leftShortcut: QShortcut | null;
    // short cut effect
    useEffect(() => {
        if (windowRef.current) {
            spaceShortcut = new QShortcut(windowRef.current);
            rightShortcut = new QShortcut(windowRef.current);
            leftShortcut = new QShortcut(windowRef.current);

            spaceShortcut.setKey(new QKeySequence("SPACE"));
            rightShortcut.setKey(new QKeySequence("RIGHT"));
            leftShortcut.setKey(new QKeySequence("LEFT"));

            async function spaceAction() {
                try {
                    currentTrack &&
                    audioPlayer.isRunning() &&
                    (await audioPlayer.isPaused())
                        ? await audioPlayer.play()
                        : await audioPlayer.pause();
                    console.log("You pressed SPACE");
                } catch (error) {
                    showError(error, "[Failed to play/pause audioPlayer]: ");
                }
            }
            async function rightAction() {
                try {
                    currentTrack &&
                        audioPlayer.isRunning() &&
                        (await audioPlayer.isSeekable()) &&
                        (await audioPlayer.seek(+5));
                    console.log("You pressed RIGHT");
                } catch (error) {
                    showError(error, "[Failed to seek audioPlayer]: ");
                }
            }
            async function leftAction() {
                try {
                    currentTrack &&
                        audioPlayer.isRunning() &&
                        (await audioPlayer.isSeekable()) &&
                        (await audioPlayer.seek(-5));
                    console.log("You pressed LEFT");
                } catch (error) {
                    showError(error, "[Failed to seek audioPlayer]: ");
                }
            }

            spaceShortcut.addEventListener("activated", spaceAction);
            rightShortcut.addEventListener("activated", rightAction);
            leftShortcut.addEventListener("activated", leftAction);

            return () => {
                spaceShortcut?.removeEventListener("activated", spaceAction);
                rightShortcut?.removeEventListener("activated", rightAction);
                leftShortcut?.removeEventListener("activated", leftAction);
                spaceShortcut = null;
                rightShortcut = null;
                leftShortcut = null;
            };
        }
    });

    return (
        <Window
            ref={windowRef}
            windowState={WindowState.WindowMaximized}
            windowIcon={winIcon}
            windowTitle="Spotube"
            minSize={minSize}
        >
            <MemoryRouter>
                <authContext.Provider
                    value={{
                        isLoggedIn,
                        setIsLoggedIn,
                        access_token,
                        setAccess_token,
                        ...credentials,
                        setCredentials,
                    }}
                >
                    <preferencesContext.Provider
                        value={{ ...preferences, setPreferences }}
                    >
                        <playerContext.Provider
                            value={{
                                currentPlaylist,
                                currentTrack,
                                setCurrentPlaylist,
                                setCurrentTrack,
                            }}
                        >
                            <QueryClientProvider client={queryClient}>
                                <View
                                    style={`flex: 1; flex-direction: 'column'; align-items: 'stretch';`}
                                >
                                    <Routes />
                                    {isLoggedIn && <Player />}
                                </View>
                            </QueryClientProvider>
                        </playerContext.Provider>
                    </preferencesContext.Provider>
                </authContext.Provider>
            </MemoryRouter>
        </Window>
    );
}

class App extends React.Component {
    render() {
        return <RootApp />;
    }
}

export default hot(App);
