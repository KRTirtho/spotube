import { QAbstractButtonSignals } from "@nodegui/nodegui";
import { Button, ScrollArea, Text, View } from "@nodegui/react-nodegui";
import React from "react";
import { RefetchOptions } from "react-query";
import { useLocation, useParams } from "react-router";
import { QueryCacheKeys } from "../conf";
import useSpotifyInfiniteQuery from "../hooks/useSpotifyInfiniteQuery";
import BackButton from "./BackButton";
import PlaceholderApplet from "./shared/PlaceholderApplet";
import PlaylistCard from "./shared/PlaylistCard";

function PlaylistGenreView() {
    const { id } = useParams<{ id: string }>();
    const location = useLocation<{ name: string }>();
    const {
        data: pagedPlaylists,
        isError,
        isLoading,
        refetch,
        hasNextPage,
        isFetchingNextPage,
        fetchNextPage,
    } = useSpotifyInfiniteQuery<
        SpotifyApi.PagingObject<SpotifyApi.PlaylistObjectSimplified>
    >(
        [QueryCacheKeys.genrePlaylists, id],
        async (spotifyApi, { pageParam }) => {
            const option = { limit: 20, offset: pageParam };
            let res;
            if (id === "featured") {
                res = await spotifyApi.getFeaturedPlaylists(option);
            } else {
                res = await spotifyApi.getPlaylistsForCategory(id, option);
            }
            return res.body.playlists;
        },
        {
            getNextPageParam(lastPage) {
                if (lastPage.next) {
                    return lastPage.offset + lastPage.limit;
                }
            },
        },
    );

    const playlists = pagedPlaylists?.pages
        .map((page) => page.items)
        .filter(Boolean)
        .flat(1);

    return (
        <GenreView
            isError={isError}
            isLoading={isLoading || isFetchingNextPage}
            refetch={refetch}
            heading={location.state.name}
            playlists={playlists ?? []}
            loadMore={hasNextPage ? () => fetchNextPage() : undefined}
            isLoadable={!isFetchingNextPage}
        />
    );
}

export default PlaylistGenreView;

interface GenreViewProps {
    heading: string;
    playlists: SpotifyApi.PlaylistObjectSimplified[];
    loadMore?: QAbstractButtonSignals["clicked"];
    isLoadable?: boolean;
    isError: boolean;
    isLoading: boolean;
    refetch: (options?: RefetchOptions | undefined) => Promise<unknown>;
}

export function GenreView({
    heading,
    playlists,
    loadMore,
    isLoadable,
    isError,
    isLoading,
    refetch,
}: GenreViewProps) {
    const playlistGenreViewStylesheet = `
    #genre-container{
      flex-direction: 'column';
      flex: 1;
    }
    #heading {
      padding: 10px;
    }
    #scroll-view{
      flex-grow: 1;
      border: none;
    }
    #child-container {
      flex-direction: "row";
      justify-content: "space-evenly";
      align-items: 'center';
      flex-wrap: "wrap";
      width: 330px;
    }
  `;
    return (
        <View id="genre-container" styleSheet={playlistGenreViewStylesheet}>
            <BackButton />
            <Text id="heading">{`<h2>${heading}</h2>`}</Text>
            <ScrollArea id="scroll-view">
                <View id="child-container">
                    <PlaceholderApplet
                        error={isError}
                        loading={isLoading}
                        reload={refetch}
                        message={`Failed loading ${heading}'s playlists`}
                    />
                    {playlists?.map((playlist, index) => {
                        return (
                            <PlaylistCard key={index + playlist.id} playlist={playlist} />
                        );
                    })}
                    {loadMore && (
                        <Button
                            text="Load more"
                            on={{ clicked: loadMore }}
                            enabled={isLoadable}
                        />
                    )}
                </View>
            </ScrollArea>
        </View>
    );
}
