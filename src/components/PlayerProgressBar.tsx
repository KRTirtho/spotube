import { Direction, Orientation, QAbstractSliderSignals } from "@nodegui/nodegui";
import { BoxView, Slider, Text, useEventHandler } from "@nodegui/react-nodegui";
import NodeMpv from "node-mpv";
import React, { useContext, useEffect, useState } from "react";
import playerContext from "../context/playerContext";

interface PlayerProgressBarProps {
  audioPlayer: NodeMpv;
  totalDuration: number;
}

function PlayerProgressBar({ audioPlayer, totalDuration }: PlayerProgressBarProps) {
  const { currentTrack } = useContext(playerContext);
  const [trackTime, setTrackTime] = useState(0);
  const trackSliderEvents = useEventHandler<QAbstractSliderSignals>(
    {
      sliderMoved: (value) => {
        if (audioPlayer.isRunning() && currentTrack) {
          const newPosition = (totalDuration * value) / 100;
          setTrackTime(parseInt(newPosition.toString()));
        }
      },
      sliderReleased: () => {
        (async () => {
          try {
            await audioPlayer.goToPosition(trackTime);
          } catch (error) {
            console.error(error);
          }
        })();
      },
    },
    [currentTrack, totalDuration, trackTime]
  );

  useEffect(() => {
    const progressListener = (seconds: number) => {
      setTrackTime(seconds);
    };
    const statusListener = ({ property }: import("node-mpv").StatusObject): void => {
      if (property === "filename") {
        setTrackTime(0);
      }
    };
    audioPlayer.on("status", statusListener);
    audioPlayer.on("timeposition", progressListener);
    return () => {
      audioPlayer.off("status", statusListener);
      audioPlayer.off("timeposition", progressListener);
    };
  });
  const playbackPercentage = totalDuration > 0 ? (trackTime * 100) / totalDuration : 0;
  return (
    <BoxView direction={Direction.LeftToRight} style={`padding: 20px 0px; flex-direction: row;`}>
      <Slider enabled={!!currentTrack || trackTime > 0} on={trackSliderEvents} sliderPosition={playbackPercentage} hasTracking orientation={Orientation.Horizontal} />
      <Text>{new Date(trackTime * 1000).toISOString().substr(14, 5) + "/" + new Date(totalDuration * 1000).toISOString().substr(14, 5)}</Text>
    </BoxView>
  );
}

export default PlayerProgressBar;
