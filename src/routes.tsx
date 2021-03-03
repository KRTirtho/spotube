import React, { useContext } from "react";
import {View} from "@nodegui/react-nodegui";
import { Route } from "react-router";
import authContext from "./context/authContext";
import Home from "./components/Home";
import Login from "./components/Login";
import PlaylistView from "./components/PlaylistView";
import PlaylistGenreView from "./components/PlaylistGenreView";
import TabMenu from "./components/TabMenu";

function Routes() {
  const {
    isLoggedIn
  } = useContext(authContext);
  return (
    <>
      <Route path="/">
        { isLoggedIn ?
          <View style="background-color: black; flex: 1; flex-direction: 'column';">
          <TabMenu />
          <Route exact path="/"><Home/></Route>
          <Route exact path="/playlist/:id"><PlaylistView /></Route>
          <Route exact path="/genre/playlists/:id"><PlaylistGenreView /></Route>
          </View>
          : <Login/>
         }

      </Route>
    </>
  );
}

export default Routes;
