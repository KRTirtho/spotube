import { Direction, Orientation, QAbstractSliderSignals, QIcon } from "@nodegui/nodegui";
import {
    BoxView,
    GridColumn,
    GridRow,
    GridView,
    Slider,
    Text,
    useEventHandler,
} from "@nodegui/react-nodegui";
import React, { ReactElement, useContext, useEffect, useState } from "react";
import playerContext, { CurrentPlaylist } from "../context/playerContext";
import { shuffleArray } from "../helpers/shuffleArray";
import NodeMpv from "node-mpv";
import { getYoutubeTrack, YoutubeTrack } from "../helpers/getYoutubeTrack";
import PlayerProgressBar from "./PlayerProgressBar";
import {
    random as shuffleIcon,
    play,
    pause,
    backward,
    forward,
    stop,
    heartRegular,
    heart,
    musicNode,
    download,
} from "../icons";
import IconButton from "./shared/IconButton";
import showError from "../helpers/showError";
import useTrackReaction from "../hooks/useTrackReaction";
import ManualLyricDialog from "./ManualLyricDialog";
import { LocalStorageKeys } from "../conf";
import useDownloadQueue from "../hooks/useDownloadQueue";

export const audioPlayer = new NodeMpv(
    {
        audio_only: true,
        auto_restart: true,
        time_update: 1,
        binary: process.env.MPV_EXECUTABLE,
        // debug: true,
        // verbose: true,
    },
    ["--ytdl-raw-options-set=format=140,http-chunk-size=300000"],
);
function Player(): ReactElement {
    const { currentTrack, currentPlaylist, setCurrentTrack, setCurrentPlaylist } =
        useContext(playerContext);
    const { reactToTrack, isFavorite } = useTrackReaction();

    const cachedVolume = localStorage.getItem(LocalStorageKeys.volume);

    const [isPaused, setIsPaused] = useState(true);
    const [volume, setVolume] = useState<number>(() =>
        cachedVolume ? parseFloat(cachedVolume) : 55,
    );
    const [totalDuration, setTotalDuration] = useState<number>(0);
    const [shuffle, setShuffle] = useState<boolean>(false);
    const [realPlaylist, setRealPlaylist] = useState<CurrentPlaylist["tracks"]>([]);
    const [isStopped, setIsStopped] = useState<boolean>(false);
    const [openLyrics, setOpenLyrics] = useState<boolean>(false);
    const [currentYtTrack, setCurrentYtTrack] = useState<YoutubeTrack>();
    const { addToQueue, isActiveDownloading, isFinishedDownloading } = useDownloadQueue();

    const playlistTracksIds = currentPlaylist?.tracks?.map((t) => t.track.id) ?? [];
    const volumeHandler = useEventHandler<QAbstractSliderSignals>(
        {
            sliderMoved: (value) => {
                setVolume(value);
            },
            sliderReleased: () => {
                localStorage.setItem(LocalStorageKeys.volume, volume.toString());
            },
        },
        [volume],
    );
    const playerRunning = audioPlayer.isRunning();
    const cachedPlaylist = localStorage.getItem(LocalStorageKeys.cachedPlaylist);
    const cachedTrack = localStorage.getItem(LocalStorageKeys.cachedTrack);

    // initial Effect
    useEffect(() => {
        (async () => {
            try {
                if (!playerRunning) {
                    await audioPlayer.start();
                    await audioPlayer.volume(volume);
                }
            } catch (error) {
                showError(error, "[Failed starting audio player]: ");
            }
        })().then(() => {
            if (cachedPlaylist && !currentPlaylist) {
                setCurrentPlaylist(JSON.parse(cachedPlaylist));
            }
            if (cachedTrack && !currentTrack) {
                setCurrentTrack(JSON.parse(cachedTrack));
            }
        });

        return () => {
            if (playerRunning) {
                audioPlayer.quit().catch((e: unknown) => console.log(e));
            }
        };
    }, []);

    // track change effect
    useEffect(() => {
        // caching current track
        if (!currentTrack) localStorage.removeItem(LocalStorageKeys.cachedTrack);
        else
            localStorage.setItem(
                LocalStorageKeys.cachedTrack,
                JSON.stringify(currentTrack),
            );

        (async () => {
            try {
                if (currentTrack && playerRunning) {
                    const youtubeTrack = await getYoutubeTrack(currentTrack);
                    setCurrentYtTrack(youtubeTrack);
                    await audioPlayer.load(youtubeTrack.youtube_uri, "replace");
                    await audioPlayer.play();
                    setIsPaused(false);
                }
                setIsStopped(false);
            } catch (error) {
                if (error.errcode !== 5) {
                    setIsStopped(true);
                    setIsPaused(true);
                }
                showError(error, "[Failure at track change]: ");
            }
        })();
    }, [currentTrack]);

    // changing shuffle to default
    useEffect(() => {
        setShuffle(false);
        // caching playlist
        if (!currentPlaylist) localStorage.removeItem(LocalStorageKeys.cachedPlaylist);
        else
            localStorage.setItem(
                LocalStorageKeys.cachedPlaylist,
                JSON.stringify(currentPlaylist),
            );
    }, [currentPlaylist]);

    useEffect(() => {
        if (playerRunning) {
            audioPlayer.volume(volume);
        }
    }, [volume]);

    // for monitoring shuffle playlist
    useEffect(() => {
        if (currentPlaylist) {
            if (shuffle && realPlaylist.length === 0) {
                const shuffledTracks = shuffleArray(currentPlaylist.tracks);
                setRealPlaylist(currentPlaylist.tracks);
                setCurrentPlaylist({ ...currentPlaylist, tracks: shuffledTracks });
            } else if (!shuffle && realPlaylist.length > 0) {
                setCurrentPlaylist({ ...currentPlaylist, tracks: realPlaylist });
            }
        }
    }, [shuffle]);

    // live Effect
    useEffect(() => {
        if (playerRunning) {
            // eslint-disable-next-line @typescript-eslint/no-explicit-any
            const statusListener = (status: { property: string; value: any }) => {
                if (status?.property === "duration") {
                    setTotalDuration(status.value ?? 0);
                }
            };
            const stopListener = () => {
                setIsStopped(true);
                setIsPaused(true);
                // go to next track
                if (
                    currentTrack &&
                    playlistTracksIds &&
                    currentPlaylist?.tracks.length !== 0
                ) {
                    const index = playlistTracksIds?.indexOf(currentTrack.id) + 1;
                    setCurrentTrack(
                        currentPlaylist?.tracks[
                            index > playlistTracksIds.length - 1 ? 0 : index
                        ].track,
                    );
                }
            };
            const pauseListener = () => {
                setIsPaused(true);
            };
            const resumeListener = () => {
                setIsPaused(false);
            };
            audioPlayer.on("status", statusListener);
            audioPlayer.on("stopped", stopListener);
            audioPlayer.on("paused", pauseListener);
            audioPlayer.on("resumed", resumeListener);
            return () => {
                audioPlayer.off("status", statusListener);
                audioPlayer.off("stopped", stopListener);
                audioPlayer.off("paused", pauseListener);
                audioPlayer.off("resumed", resumeListener);
            };
        }
    });

    const handlePlayPause = async () => {
        try {
            if ((await audioPlayer.isPaused()) && playerRunning) {
                await audioPlayer.play();
                setIsStopped(false);
                setIsPaused(false);
            } else {
                await audioPlayer.pause();
                setIsStopped(true);
                setIsPaused(true);
            }
        } catch (error) {
            showError(error, "[Track control failed]: ");
        }
    };

    const prevOrNext = (constant: number) => {
        if (currentTrack && playlistTracksIds && currentPlaylist) {
            const index = playlistTracksIds.indexOf(currentTrack.id) + constant;
            setCurrentTrack(
                currentPlaylist.tracks[
                    index > playlistTracksIds?.length - 1
                        ? 0
                        : index < 0
                        ? playlistTracksIds.length - 1
                        : index
                ].track,
            );
        }
    };

    async function stopPlayback() {
        try {
            if (playerRunning) {
                setCurrentTrack(undefined);
                setCurrentPlaylist(undefined);
                await audioPlayer.stop();
            }
        } catch (error) {
            showError(error, "[Failed at audio-player stop]: ");
        }
    }

    const artistsNames = currentTrack?.artists?.map((x) => x.name);
    return (
        <GridView enabled={!!currentTrack} style="flex: 1; max-height: 120px;">
            <GridRow>
                <GridColumn width={2}>
                    <Text wordWrap openExternalLinks>
                        {artistsNames && currentTrack
                            ? `
            <p><b><a href="${currentYtTrack?.youtube_uri}"}>${
                                  currentTrack.name
                              }</a></b> - ${artistsNames[0]} ${
                                  artistsNames.length > 1
                                      ? "feat. " + artistsNames.slice(1).join(", ")
                                      : ""
                              }</p>
            `
                            : `<b>Oh, dear don't waste time</b>`}
                    </Text>
                </GridColumn>
                <GridColumn width={4}>
                    <BoxView
                        direction={Direction.TopToBottom}
                        style={`max-width: 600px; min-width: 380px;`}
                    >
                        {currentTrack && (
                            <ManualLyricDialog open={openLyrics} track={currentTrack} />
                        )}
                        <PlayerProgressBar
                            audioPlayer={audioPlayer}
                            totalDuration={totalDuration}
                        />

                        <BoxView direction={Direction.LeftToRight}>
                            <IconButton
                                style={`background-color: ${
                                    shuffle ? "orange" : "rgba(255, 255, 255, 0.055)"
                                }`}
                                on={{ clicked: () => setShuffle(!shuffle) }}
                                icon={new QIcon(shuffleIcon)}
                            />
                            <IconButton
                                on={{ clicked: () => prevOrNext(-1) }}
                                icon={new QIcon(backward)}
                            />
                            <IconButton
                                on={{ clicked: handlePlayPause }}
                                icon={
                                    new QIcon(
                                        isStopped || isPaused || !currentTrack
                                            ? play
                                            : pause,
                                    )
                                }
                            />
                            <IconButton
                                on={{ clicked: () => prevOrNext(1) }}
                                icon={new QIcon(forward)}
                            />
                            <IconButton
                                icon={new QIcon(stop)}
                                on={{ clicked: stopPlayback }}
                            />
                        </BoxView>
                    </BoxView>
                </GridColumn>
                <GridColumn width={2}>
                    <BoxView>
                        <IconButton
                            style={
                                isActiveDownloading() && !isFinishedDownloading()
                                    ? "background-color: green;"
                                    : ""
                            }
                            enabled={!!currentYtTrack}
                            icon={new QIcon(download)}
                            on={{
                                clicked() {
                                    currentYtTrack && addToQueue(currentYtTrack);
                                },
                            }}
                        />
                        <IconButton
                            on={{
                                clicked() {
                                    if (currentTrack) {
                                        reactToTrack({
                                            added_at: Date.now().toString(),
                                            track: currentTrack,
                                        });
                                    }
                                },
                            }}
                            icon={
                                new QIcon(
                                    isFavorite(currentTrack?.id ?? "")
                                        ? heart
                                        : heartRegular,
                                )
                            }
                        />
                        <IconButton
                            style={openLyrics ? "background-color: green;" : ""}
                            icon={new QIcon(musicNode)}
                            on={{
                                clicked: () => currentTrack && setOpenLyrics(!openLyrics),
                            }}
                        />
                        <Slider
                            minSize={{ height: 20, width: 80 }}
                            maxSize={{ height: 20, width: 100 }}
                            hasTracking
                            sliderPosition={volume}
                            on={volumeHandler}
                            orientation={Orientation.Horizontal}
                        />
                    </BoxView>
                </GridColumn>
            </GridRow>
        </GridView>
    );
}

export default Player;
