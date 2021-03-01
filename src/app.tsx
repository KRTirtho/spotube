import React, { useState, useEffect, useRef } from "react";
import { Window, hot, View, useEventHandler, BoxView } from "@nodegui/react-nodegui";
import { Direction, QIcon, QKeyEvent, QMainWindow, QMainWindowSignals, WidgetEventTypes, WindowState } from "@nodegui/nodegui";
import nodeguiIcon from "../assets/nodegui.jpg";
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

export enum CredentialKeys {
  credentials = "credentials",
  refresh_token = "refresh_token",
}

export interface Credentials {
  clientId: string;
  clientSecret: string;
}

const minSize = { width: 700, height: 750 };
const winIcon = new QIcon(nodeguiIcon);
global.localStorage = new LocalStorage("./local");
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      onError(error) {
        showError(error);
      },
    },
  },
});

function RootApp() {
  const windowRef = useRef<QMainWindow>();
  const [currentTrack, setCurrentTrack] = useState<CurrentTrack>();

  const windowEvents = useEventHandler<QMainWindowSignals>(
    {
      async KeyRelease(nativeEv) {
        try {
          if (nativeEv) {
            const event = new QKeyEvent(nativeEv);
            const eventKey = event.key();
            console.log("eventKey:", eventKey);
            if (audioPlayer.isRunning() && currentTrack)
              switch (eventKey) {
                case 32: //space
                  (await audioPlayer.isPaused()) ? await audioPlayer.play() : await audioPlayer.pause();
                  break;
                case 16777236: //arrow-right
                  (await audioPlayer.isSeekable()) && (await audioPlayer.seek(+5));
                  break;
                case 16777234: //arrow-left
                  (await audioPlayer.isSeekable()) && (await audioPlayer.seek(-5));
                  break;
                default:
                  break;
              }
          }
        } catch (error) {
          console.error("Error in window events: ", error);
        }
      },
    },
    [currentTrack]
  );

  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);
  const [credentials, setCredentials] = useState<Credentials>({ clientId: "", clientSecret: "" });
  const [expires_in, setExpires_in] = useState<number>(0);
  const [access_token, setAccess_token] = useState<string>("");
  const [currentPlaylist, setCurrentPlaylist] = useState<CurrentPlaylist>();
  const cachedCredentials = localStorage.getItem(CredentialKeys.credentials);

  const setExpireTime = (expirationDuration: number) => setExpires_in(Date.now() + expirationDuration * 1000 /* 1s = 1000 ms */);

  useEffect(() => {
    setIsLoggedIn(!!cachedCredentials);
  }, []);

  useEffect(() => {
    const onWindowClose = () => {
      if (audioPlayer.isRunning()) {
        audioPlayer.stop().catch((e) => console.error("Failed to quit MPV player: ", e));
      }
    };

    windowRef.current?.addEventListener(WidgetEventTypes.Close, onWindowClose);
    return () => {
      windowRef.current?.removeEventListener(WidgetEventTypes.Close, onWindowClose);
    };
  });
  // for user code login
  useEffect(() => {
    if (isLoggedIn && credentials && !localStorage.getItem(CredentialKeys.refresh_token)) {
      const app = express();
      app.use(express.json());

      app.get<null, null, null, { code: string }>("/auth/spotify/callback", async (req, res) => {
        try {
          spotifyApi.setClientId(credentials.clientId);
          spotifyApi.setClientSecret(credentials.clientSecret);
          const { body: authRes } = await spotifyApi.authorizationCodeGrant(req.query.code);
          setAccess_token(authRes.access_token);
          setExpireTime(authRes.expires_in);
          localStorage.setItem(CredentialKeys.refresh_token, authRes.refresh_token);
          return res.end();
        } catch (error) {
          console.error("Failed to fullfil code grant flow: ", error);
        }
      });

      const server = app.listen(4304, () => {
        console.log("Server is running");
        open(spotifyApi.createAuthorizeURL(["user-library-read", "user-library-modify"], "xxxyyysssddd")).catch((e) => console.error("Opening IPC connection with browser failed: ", e));
      });
      return () => {
        server.close(() => console.log("Closed server"));
      };
    }
  }, [isLoggedIn, credentials]);

  useEffect(() => {
    if (cachedCredentials) {
      setCredentials(JSON.parse(cachedCredentials));
    }
  }, [isLoggedIn]);

  return (
    <Window ref={windowRef} on={windowEvents} windowState={WindowState.WindowMaximized} windowIcon={winIcon} windowTitle="Spotube" minSize={minSize}>
      <MemoryRouter>
        <authContext.Provider value={{ isLoggedIn, setIsLoggedIn, access_token, expires_in, setAccess_token, setExpires_in: setExpireTime, ...credentials }}>
          <playerContext.Provider value={{ currentPlaylist, currentTrack, setCurrentPlaylist, setCurrentTrack }}>
            <QueryClientProvider client={queryClient}>
              {/* <View style={`flex: 1; flex-direction: 'column'; justify-content: 'center'; align-items: 'stretch'; height: '100%';`}> */}
              <BoxView direction={Direction.TopToBottom}>
                <Routes />
                {isLoggedIn && <Player />}
              </BoxView>
              {/* </View> */}
            </QueryClientProvider>
          </playerContext.Provider>
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
