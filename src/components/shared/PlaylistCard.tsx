import { CursorShape, QIcon, QMouseEvent } from "@nodegui/nodegui";
import { Text, View } from "@nodegui/react-nodegui";
import React, { useContext, useMemo, useState } from "react";
import { useHistory } from "react-router";
import { QueryCacheKeys } from "../../conf";
import playerContext from "../../context/playerContext";
import preferencesContext from "../../context/preferencesContext";
import { generateRandomColor, getDarkenForeground } from "../../helpers/RandomColor";
import { useLogger } from "../../hooks/useLogger";
import usePlaylistReaction from "../../hooks/usePlaylistReaction";
import useSpotifyQuery from "../../hooks/useSpotifyQuery";
import { heart, heartRegular, pause, play } from "../../icons";
import { audioPlayer } from "../Player";
import CachedImage from "./CachedImage";
import IconButton from "./IconButton";

interface PlaylistCardProps {
    playlist: SpotifyApi.PlaylistObjectSimplified;
}

const PlaylistCard = ({ playlist }: PlaylistCardProps) => {
    const logger = useLogger(PlaylistCard.name);
    const preferences = useContext(preferencesContext);
    const thumbnail = playlist.images[0].url;
    const { id, description, name } = playlist;
    const history = useHistory();
    const [hovered, setHovered] = useState(false);
    const { setCurrentTrack, currentPlaylist, setCurrentPlaylist } =
        useContext(playerContext);
    const { refetch } = useSpotifyQuery<SpotifyApi.PlaylistTrackObject[]>(
        [QueryCacheKeys.playlistTracks, id],
        (spotifyApi) =>
            spotifyApi.getPlaylistTracks(id).then((track) => track.body.items),
        {
            initialData: [],
            enabled: false,
        },
    );
    const { reactToPlaylist, isFavorite } = usePlaylistReaction();

    const handlePlaylistPlayPause = async () => {
        try {
            const { data: tracks, isSuccess } = await refetch();
            if (currentPlaylist?.id !== id && isSuccess && tracks) {
                setCurrentPlaylist({ tracks, id, name, thumbnail });
                setCurrentTrack(tracks[0].track);
            } else {
                await audioPlayer.stop();
                setCurrentTrack(undefined);
                setCurrentPlaylist(undefined);
            }
        } catch (error: any) {
            logger.error("Failed adding playlist to queue", error);
        }
    };

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    function gotoPlaylist(native?: any) {
        const key = new QMouseEvent(native);
        if (key.button() === 1) {
            history.push(`/playlist/${id}`, { name, thumbnail });
        }
    }

    const bgColor1 = useMemo(() => generateRandomColor(), []);
    const color = useMemo(() => getDarkenForeground(bgColor1), [bgColor1]);

    const playlistStyleSheet = `
    #playlist-container, #img-container{
      width: 150px;
      padding: 10px;
      margin: 5px;
      flex-direction: column;
      background-color: ${bgColor1};
    }
    #playlist-container{
      border-radius: 5px;
      min-height: 150px;
    }
    #playlist-container:hover{
      border: 1px solid green;
    }
    #playlist-container:clicked{
      border: 5px solid green;
    }
  `;
    const playlistAction = `
    position: absolute;
    bottom: 30px;
    background-color: ${color};
  `;

    const playlistActions = (
        <>
            <IconButton
                style={preferences.playlistImages ? "" : playlistAction + "left: '55%'"}
                icon={new QIcon(isFavorite(id) ? heart : heartRegular)}
                on={{
                    clicked() {
                        reactToPlaylist(playlist);
                    },
                }}
            />
            <IconButton
                style={preferences.playlistImages ? "" : playlistAction + "left: '80%'"}
                icon={new QIcon(currentPlaylist?.id === id ? pause : play)}
                on={{
                    clicked() {
                        handlePlaylistPlayPause();
                    },
                }}
            />
        </>
    );
    const hovers = {
        HoverEnter() {
            setHovered(true);
        },
        HoverLeave() {
            setHovered(false);
        },
    };

    return (
        <View
            id={preferences.playlistImages ? "img-container" : "playlist-container"}
            cursor={CursorShape.PointingHandCursor}
            styleSheet={playlistStyleSheet}
            on={{
                MouseButtonRelease: gotoPlaylist,
                ...hovers,
            }}
        >
            {preferences.playlistImages && (
                <CachedImage
                    src={thumbnail}
                    maxSize={{ height: 150, width: 150 }}
                    scaledContents
                    alt={name}
                />
            )}

            <Text
                style={`color: ${color};`}
                wordWrap
                on={{ MouseButtonRelease: gotoPlaylist, ...hovers }}
            >
                {`
          <center>
            <h3>${name}</h3>
            <p>${description}</p>
          </center>
        `}
            </Text>

            {(hovered || currentPlaylist?.id === id) &&
                !preferences.playlistImages &&
                playlistActions}
            {preferences.playlistImages && (
                <View style="flex: 1; justify-content: 'space-around';">
                    {playlistActions}
                </View>
            )}
        </View>
    );
};

export default PlaylistCard;
