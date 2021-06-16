import React, { FC, useContext } from "react";
import { View, ScrollArea, Text } from "@nodegui/react-nodegui";
import BackButton from "./BackButton";
import { useLocation, useParams } from "react-router";
import { QIcon } from "@nodegui/nodegui";
import playerContext from "../context/playerContext";
import IconButton from "./shared/IconButton";
import { heart, heartRegular, play, stop } from "../icons";
import { audioPlayer } from "./Player";
import { QueryCacheKeys } from "../conf";
import useSpotifyQuery from "../hooks/useSpotifyQuery";
import usePlaylistReaction from "../hooks/usePlaylistReaction";
import { TrackButton } from "./shared/TrackButton";
import PlaceholderApplet from "./shared/PlaceholderApplet";

export interface PlaylistTrackRes {
    name: string;
    artists: string;
    url: string;
}

const PlaylistView: FC = () => {
    const { setCurrentTrack, currentPlaylist, setCurrentPlaylist } =
        useContext(playerContext);
    const params = useParams<{ id: string }>();
    const location = useLocation<{ name: string; thumbnail: string }>();
    const { isFavorite, reactToPlaylist } = usePlaylistReaction();
    const { data: playlist } = useSpotifyQuery<SpotifyApi.PlaylistObjectFull>(
        [QueryCacheKeys.categoryPlaylists, params.id],
        (spotifyApi) =>
            spotifyApi.getPlaylist(params.id).then((playlistsRes) => playlistsRes.body),
    );
    const {
        data: tracks,
        isSuccess,
        isError,
        isLoading,
        refetch,
    } = useSpotifyQuery<SpotifyApi.PlaylistTrackObject[]>(
        [QueryCacheKeys.playlistTracks, params.id],
        (spotifyApi) =>
            spotifyApi.getPlaylistTracks(params.id).then((track) => track.body.items),
        { initialData: [] },
    );

    const handlePlaylistPlayPause = () => {
        if (currentPlaylist?.id !== params.id && isSuccess && tracks) {
            setCurrentPlaylist({ ...params, ...location.state, tracks });
            setCurrentTrack(tracks[0].track);
        } else {
            audioPlayer
                .stop()
                .catch((error) => console.error("Failed to stop audio player: ", error));
            setCurrentTrack(undefined);
            setCurrentPlaylist(undefined);
        }
    };

    return (
        <View style={`flex: 1; flex-direction: 'column';`}>
            <PlaylistSimpleControls
                handlePlaylistReact={() => playlist && reactToPlaylist(playlist)}
                handlePlaylistPlayPause={handlePlaylistPlayPause}
                isActive={currentPlaylist?.id === params.id}
                isFavorite={isFavorite(params.id)}
            />
            <Text>{`<center><h2>${location.state.name[0].toUpperCase()}${location.state.name.slice(
                1,
            )}</h2></center>`}</Text>
            {<TrackTableIndex />}
            <ScrollArea style={`flex:1; flex-grow: 1; border: none;`}>
                <View style={`flex-direction:column; flex: 1;`}>
                    <PlaceholderApplet
                        error={isError}
                        loading={isLoading}
                        reload={refetch}
                        message={`Failed retrieving ${location.state.name} tracks`}
                    />
                    {tracks?.map(({ track }, index) => {
                        if (track) {
                            return (
                                <TrackButton
                                    key={index + track.id}
                                    track={track}
                                    index={index}
                                    playlist={playlist}
                                />
                            );
                        }
                    })}
                </View>
            </ScrollArea>
        </View>
    );
};

export default PlaylistView;

export function TrackTableIndex() {
    return (
        <View>
            <Text style="padding: 5px;">{`<h3>#</h3>`}</Text>
            <Text style="width: '35%';">{`<h3>Title</h3>`}</Text>
            <Text style="width: '25%';">{`<h3>Album</h3>`}</Text>
            <Text style="width: '15%';">{`<h3>Duration</h3>`}</Text>
            <Text style="width: '15%';">{`<h3>Actions</h3>`}</Text>
        </View>
    );
}
interface PlaylistSimpleControlsProps {
    handlePlaylistPlayPause: (index?: number) => void;
    handlePlaylistReact?: () => void;
    isActive: boolean;
    isFavorite?: boolean;
}

export function PlaylistSimpleControls({
    handlePlaylistPlayPause,
    isActive,
    handlePlaylistReact,
    isFavorite,
}: PlaylistSimpleControlsProps) {
    return (
        <View style={`justify-content: 'space-evenly'; max-width: 150px; padding: 10px;`}>
            <BackButton />
            {isFavorite !== undefined && (
                <IconButton
                    icon={new QIcon(isFavorite ? heart : heartRegular)}
                    on={{ clicked: handlePlaylistReact }}
                />
            )}
            <IconButton
                style={`background-color: #00be5f; color: white;`}
                on={{
                    clicked() {
                        handlePlaylistPlayPause();
                    },
                }}
                icon={new QIcon(isActive ? stop : play)}
            />
        </View>
    );
}
