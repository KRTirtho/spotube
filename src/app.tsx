import React, { useState, useEffect, useRef } from "react";
import { Window, hot, View } from "@nodegui/react-nodegui";
import { QIcon, QMainWindow, WidgetEventTypes, WindowState } from "@nodegui/nodegui";
import nodeguiIcon from "../assets/nodegui.jpg";
import { MemoryRouter } from "react-router";
import Routes from "./routes";
import SpotifyWebApi from "spotify-web-api-node";
import { LocalStorage } from "node-localstorage";
import authContext from "./context/authContext";
import playerContext, { CurrentPlaylist, CurrentTrack } from "./context/playerContext";
import Player, { audioPlayer } from "./components/Player";
import { redirectURI } from "./conf";

export enum CredentialKeys {
  credentials = "credentials",
  refresh_token = "refresh_token"
}

export interface Credentials {
  clientId: string;
  clientSecret: string;
}

const minSize = { width: 700, height: 750 };
const winIcon = new QIcon(nodeguiIcon);
global.localStorage = new LocalStorage("./local");

function RootApp() {
  const windowRef = useRef<QMainWindow>();
  const [isLoggedIn, setIsLoggedIn] = useState<boolean>(false);
  const [credentials, setCredentials] = useState<Credentials>({ clientId: "", clientSecret: "" });
  const [access_token, setAccess_token] = useState<string>("");
  const [currentPlaylist, setCurrentPlaylist] = useState<CurrentPlaylist>();
  const [currentTrack, setCurrentTrack] = useState<CurrentTrack>();

  const spotifyApi = new SpotifyWebApi({ redirectUri: redirectURI, ...credentials });
  const cachedCredentials = localStorage.getItem(CredentialKeys.credentials);

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

  useEffect(() => {
    if (isLoggedIn) {
      spotifyApi
        .clientCredentialsGrant()
        .then(({ body: { access_token } }) => {
          setAccess_token(access_token);
        })
        .catch((error) => {
          console.error("Spotify Client Credential not granted for: ", error);
        });
    }
    if (cachedCredentials) {
      setCredentials(JSON.parse(cachedCredentials));
    }
  }, [isLoggedIn]);

  return (
    <Window ref={windowRef} windowState={WindowState.WindowMaximized} windowIcon={winIcon} windowTitle="Spotube" minSize={minSize}>
      <MemoryRouter>
        <authContext.Provider value={{ isLoggedIn, setIsLoggedIn, access_token }}>
          <playerContext.Provider value={{ spotifyApi, currentPlaylist, currentTrack, setCurrentPlaylist, setCurrentTrack }}>
            <View style={`flex: 1; flex-direction: 'column'; justify-content: 'center'; align-items: 'stretch'; height: '100%';`}>
              <Routes />
              {isLoggedIn && <Player />}
            </View>
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
