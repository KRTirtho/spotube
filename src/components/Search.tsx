import { CursorShape, QIcon, QKeyEvent, QMouseEvent } from "@nodegui/nodegui";
import { LineEdit, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React, { useState } from "react";
import { useHistory } from "react-router";
import { QueryCacheKeys } from "../conf";
import { useLogger } from "../hooks/useLogger";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import { search } from "../icons";
import { TrackTableIndex } from "./PlaylistView";
import IconButton from "./shared/IconButton";
import PlaceholderApplet from "./shared/PlaceholderApplet";
import PlaylistCard from "./shared/PlaylistCard";
import { TrackButton } from "./shared/TrackButton";

function Search() {
    const logger = useLogger(Search.name);
    const history = useHistory<{ searchQuery: string }>();
    const [searchQuery, setSearchQuery] = useState<string>("");
    const {
        data: searchResults,
        refetch,
        isError,
        isLoading,
    } = useSpotifyQuery<SpotifyApi.SearchResponse>(
        QueryCacheKeys.search,
        (spotifyApi) =>
            spotifyApi
                .search(searchQuery, ["playlist", "track"], { limit: 4 })
                .then((res) => res.body),
        { enabled: false },
    );

    async function handleSearch() {
        try {
            await refetch();
        } catch (error: any) {
            logger.error("Failed to search through spotify", error);
        }
    }

    const placeholder = (
        <PlaceholderApplet
            error={isError}
            loading={isLoading}
            message="Failed querying spotify"
            reload={refetch}
        />
    );
    return (
        <View style="flex: 1; flex-direction: 'column'; padding: 5px;">
            <View>
                <LineEdit
                    style="width: '65%'; margin: 5px;"
                    placeholderText="Search spotify"
                    on={{
                        textChanged(t) {
                            setSearchQuery(t);
                        },
                        // eslint-disable-next-line @typescript-eslint/no-explicit-any
                        KeyRelease(native: any) {
                            const key = new QKeyEvent(native);
                            const isEnter = key.key() === 16777220;
                            if (isEnter) {
                                handleSearch();
                            }
                        },
                    }}
                />
                <IconButton
                    enabled={searchQuery.length > 0}
                    icon={new QIcon(search)}
                    on={{ clicked: handleSearch }}
                />
            </View>
            <ScrollArea style="flex: 1;">
                <View style="flex-direction: 'column'; flex: 1;">
                    <View style="flex: 1; flex-direction: 'column';">
                        <Text
                            cursor={CursorShape.PointingHandCursor}
                            on={{
                                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                                MouseButtonRelease(native: any) {
                                    if (
                                        new QMouseEvent(native).button() === 1 &&
                                        searchResults?.tracks
                                    ) {
                                        history.push("/search/songs", { searchQuery });
                                    }
                                },
                            }}
                        >{`<h2>Songs</h2>`}</Text>
                        <TrackTableIndex />
                        {placeholder}
                        {searchResults?.tracks?.items.map((track, index) => (
                            <TrackButton
                                key={index + track.id}
                                index={index}
                                track={track}
                            />
                        ))}
                    </View>
                    <View style="flex: 1; flex-direction: 'column';">
                        <Text
                            cursor={CursorShape.PointingHandCursor}
                            on={{
                                // eslint-disable-next-line @typescript-eslint/no-explicit-any
                                MouseButtonRelease(native: any) {
                                    if (
                                        new QMouseEvent(native).button() === 1 &&
                                        searchResults?.playlists
                                    ) {
                                        history.push("/search/playlists", {
                                            searchQuery,
                                        });
                                    }
                                },
                            }}
                        >{`<h2>Playlists</h2>`}</Text>
                        <View style="flex: 1; justify-content: 'space-around'; align-items: 'center';">
                            {placeholder}
                            {searchResults?.playlists?.items.map((playlist, index) => (
                                <PlaylistCard
                                    key={index + playlist.id}
                                    playlist={playlist}
                                />
                            ))}
                        </View>
                    </View>
                </View>
            </ScrollArea>
        </View>
    );
}

export default Search;
