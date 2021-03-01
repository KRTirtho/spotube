import { Direction, Orientation, QAbstractSliderSignals, QIcon, QLabel } from "@nodegui/nodegui";
import { BoxView, GridColumn, GridRow, GridView, Slider, Text, useEventHandler } from "@nodegui/react-nodegui";
import React, { ReactElement, useContext, useEffect, useRef, useState } from "react";
import playerContext, { CurrentPlaylist } from "../context/playerContext";
import { shuffleArray } from "../helpers/shuffleArray";
import NodeMpv from "node-mpv";
import { getYoutubeTrack } from "../helpers/getYoutubeTrack";
import PlayerProgressBar from "./PlayerProgressBar";
import { random as shuffleIcon, play, pause, backward, forward, stop, heartRegular } from "../icons";
import IconButton from "./shared/IconButton";
import authContext from "../context/authContext";
import useSpotifyApi from "../hooks/useSpotifyApi";
import showError from "../helpers/showError";

export const audioPlayer = new NodeMpv(
  {
    audio_only: true,
    auto_restart: true,
    time_update: 1,
    binary: process.env.MPV_EXECUTABLE ?? "/usr/bin/mpv",
    // debug: true,
    // verbose: true,
  },
  ["--ytdl-raw-options-set=format=140,http-chunk-size=300000"]
);

function Player(): ReactElement {
  const { currentTrack, currentPlaylist, setCurrentTrack, setCurrentPlaylist } = useContext(playerContext);
  const spotifyApi = useSpotifyApi();
  const { access_token } = useContext(authContext);
  const initVolume = parseFloat(localStorage.getItem("volume") ?? "55");
  const [isPaused, setIsPaused] = useState(true);
  const [volume, setVolume] = useState<number>(initVolume);
  const [totalDuration, setTotalDuration] = useState(0);
  const [shuffle, setShuffle] = useState<boolean>(false);
  const [realPlaylist, setRealPlaylist] = useState<CurrentPlaylist["tracks"]>([]);
  const [isStopped, setIsStopped] = useState<boolean>(false);
  const playlistTracksIds = currentPlaylist?.tracks.map((t) => t.track.id);
  const volumeHandler = useEventHandler<QAbstractSliderSignals>(
    {
      sliderMoved: (value) => {
        setVolume(value);
      },
      sliderReleased: () => {
        localStorage.setItem("volume", volume.toString());
      },
    },
    []
  );
  const playerRunning = audioPlayer.isRunning();
  const titleRef = useRef<QLabel>();

  // initial Effect
  useEffect(() => {
    (async () => {
      try {
        if (!playerRunning) {
          await audioPlayer.start();
          await audioPlayer.volume(initVolume);
        }
      } catch (error) {
        console.error("Failed to start audio player", error);
        showError(error, "[Failed starting audio player]: ")
      }
    })();

    return () => {
      if (playerRunning) {
        audioPlayer.quit().catch((e: any) => console.log(e));
      }
    };
  }, []);

  // useEffect(() => {
  //   (async () => {
  //     try {
  //       if (access_token) {
  //         const userSavedTrack = await spotifyApi.getMySavedTracks();
  //         console.log("userSavedTrack:", userSavedTrack);
  //       }
  //     } catch (error) {
  //       console.error("Failed to get spotify user saved tracks: ", error);
  //     }
  //   })();
  // }, [access_token]);

  // track change effect
  useEffect(() => {
    (async () => {
      try {
        if (currentTrack && playerRunning) {
          const youtubeTrack = await getYoutubeTrack(currentTrack);
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
      const statusListener = (status: { property: string; value: any }) => {
        if (status?.property === "duration") {
          setTotalDuration(status.value);
        }
      };
      const stopListener = () => {
        setIsStopped(true);
        setIsPaused(true);
        // go to next track
        if (currentTrack && playlistTracksIds && currentPlaylist?.tracks.length !== 0) {
          const index = playlistTracksIds?.indexOf(currentTrack.id) + 1;
          setCurrentTrack(currentPlaylist?.tracks[index > playlistTracksIds.length - 1 ? 0 : index].track);
        }
      };
      const pauseListener = () => {
        setIsPaused(true);
      }
      const resumeListener = () => {
        setIsPaused(false);
      };
      audioPlayer.on("status", statusListener);
      audioPlayer.on("stopped", stopListener);
      audioPlayer.on("paused", pauseListener)
      audioPlayer.on("resumed", resumeListener)
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
      setCurrentTrack(currentPlaylist.tracks[index > playlistTracksIds?.length - 1 ? 0 : index < 0 ? playlistTracksIds.length - 1 : index].track);
    }
  };

  async function stopPlayback() {
    try {
      if (playerRunning) {
        await audioPlayer.stop();
      }
    } catch (error) {
      showError(error, "[Failed at audio-player stop]: ")
    }
  }

  const artistsNames = currentTrack?.artists?.map((x) => x.name);
  return (
    <GridView enabled={!!currentTrack} style="flex: 1; max-height: 100px;">
      <GridRow>
        <GridColumn width={2}>
          <Text ref={titleRef} wordWrap>
            {artistsNames && currentTrack
              ? `
            <p><b>${currentTrack.name}</b> - ${artistsNames[0]} feat. ${artistsNames.slice(1).join(" ")}</p>
            `
              : `<b>Oh, dear don't waste time</b>`}
          </Text>
        </GridColumn>
        <GridColumn width={4}>
          <BoxView direction={Direction.TopToBottom} style={`max-width: 600px; min-width: 380px;`}>
            <PlayerProgressBar audioPlayer={audioPlayer} totalDuration={totalDuration} />

            <BoxView direction={Direction.LeftToRight}>
              <IconButton style={`background-color: ${shuffle ? "orange" : "rgba(255, 255, 255, 0.055)"}`} on={{ clicked: () => setShuffle(!shuffle) }} icon={new QIcon(shuffleIcon)} />
              <IconButton on={{ clicked: () => prevOrNext(-1) }} icon={new QIcon(backward)} />
              <IconButton on={{ clicked: handlePlayPause }} icon={new QIcon(isStopped || isPaused || !currentTrack ? play : pause)} />
              <IconButton on={{ clicked: () => prevOrNext(1) }} icon={new QIcon(forward)} />
              <IconButton icon={new QIcon(stop)} on={{ clicked: stopPlayback }} />
            </BoxView>
          </BoxView>
        </GridColumn>
        <GridColumn width={2}>
          <BoxView>
            <IconButton icon={new QIcon(heartRegular)} />
            <Slider minSize={{ height: 20, width: 80 }} maxSize={{ height: 20, width: 100 }} hasTracking sliderPosition={volume} on={volumeHandler} orientation={Orientation.Horizontal} />
          </BoxView>
        </GridColumn>
      </GridRow>
    </GridView>
  );
}

export default Player;
