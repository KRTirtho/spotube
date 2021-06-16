import React, { useContext } from "react";
import { Redirect, Route } from "react-router";
import authContext from "./context/authContext";
import Home from "./components/Home";
import Login from "./components/Login";
import PlaylistView from "./components/PlaylistView";
import PlaylistGenreView from "./components/PlaylistGenreView";
import TabMenu from "./components/TabMenu";
import CurrentPlaylist from "./components/CurrentPlaylist";
import Library from "./components/Library";
import Search from "./components/Search";
import SearchResultPlaylistCollection from "./components/SearchResultPlaylistCollection";
import SearchResultSongsCollection from "./components/SearchResultSongsCollection";
import Settings from "./components/Settings";
import Artist from "./components/Artist";

function Routes() {
    const { isLoggedIn } = useContext(authContext);
    return (
        <>
            <Route path="/">
                {isLoggedIn ? (
                    <>
                        <Redirect from="/" to="/home" />
                        <TabMenu />
                        <Route exact path="/home">
                            <Home />
                        </Route>
                        <Route exact path="/playlist/:id">
                            <PlaylistView />
                        </Route>
                        <Route exact path="/genre/playlists/:id">
                            <PlaylistGenreView />
                        </Route>
                    </>
                ) : (
                    <Login />
                )}
            </Route>
            <Route path="/currently">
                <CurrentPlaylist />
            </Route>
            <Route path="/library">
                <Library />
            </Route>
            <Route path="/artist">
                <Artist />
            </Route>
            <Route exact path="/search">
                <Search />
            </Route>
            <Route exact path="/search/playlists">
                <SearchResultPlaylistCollection />
            </Route>
            <Route exact path="/search/songs">
                <SearchResultSongsCollection />
            </Route>
            <Route exact path="/settings/">
                <Settings />
            </Route>
        </>
    );
}

export default Routes;
