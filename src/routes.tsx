import React, { useContext } from "react";
import { Route } from "react-router";
import authContext from "./context/authContext";
import Home from "./components/Home";
import Login from "./components/Login";
import PlaylistView from "./components/PlaylistView";
import PlaylistGenreView from "./components/PlaylistGenreView";

function Routes() {
  const {
    isLoggedIn
  } = useContext(authContext);
  return (
    <>
      <Route exact path="/">
        {isLoggedIn ? <Home /> : <Login />}
      </Route>
      <Route path="/playlist/:id"><PlaylistView/></Route>
      <Route path="/genre/playlists/:id"><PlaylistGenreView/></Route>
    </>
  );
}

export default Routes;
