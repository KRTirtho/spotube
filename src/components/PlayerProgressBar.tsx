import { Orientation, QAbstractSliderSignals } from "@nodegui/nodegui";
import { Slider, Text, useEventHandler, View } from "@nodegui/react-nodegui";
import NodeMpv from "node-mpv";
import React, { useContext, useEffect, useState } from "react";
import playerContext from "../context/playerContext";
import { useLogger } from "../hooks/useLogger";

interface PlayerProgressBarProps {
    audioPlayer: NodeMpv;
    totalDuration: number;
}

function PlayerProgressBar({ audioPlayer, totalDuration }: PlayerProgressBarProps) {
    const logger = useLogger(PlayerProgressBar.name);
    const { currentTrack } = useContext(playerContext);
    const [trackTime, setTrackTime] = useState<number>(0);
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
                    } catch (error: any) {
                        logger.error(error);
                    }
                })();
            },
        },
        [currentTrack, totalDuration, trackTime],
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
    const playbackTime =
        new Date(trackTime * 1000).toISOString().substr(14, 5) +
        "/" +
        new Date(totalDuration * 1000).toISOString().substr(14, 5);

    const containerStyle = `
      padding: 20px 0px; 
      flex-direction: row
    `;
    return (
        <View style={containerStyle}>
            <Slider
                enabled={!!currentTrack || trackTime > 0}
                on={trackSliderEvents}
                sliderPosition={playbackPercentage}
                hasTracking
                orientation={Orientation.Horizontal}
            />
            <Text>{playbackTime}</Text>
        </View>
    );
}

export default PlayerProgressBar;
