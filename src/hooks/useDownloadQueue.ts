import { useContext, useEffect, useState } from "react";
import ytdl from "ytdl-core";
import fs from "fs";
import { YoutubeTrack } from "../helpers/getYoutubeTrack";
import { join } from "path";
import os from "os";
import playerContext from "../context/playerContext";
import showError from "../helpers/showError";

function useDownloadQueue() {
    const [downloadQueue, setDownloadQueue] = useState<YoutubeTrack[]>([]);
    const [completedQueue, setCompletedQueue] = useState<YoutubeTrack[]>([]);
    const { currentTrack } = useContext(playerContext);

    function addToQueue(obj: YoutubeTrack) {
        setDownloadQueue([...downloadQueue, obj]);
    }
    const completedTrackIds = completedQueue.map((x) => x.id);
    const downloadingTrackIds = downloadQueue.map((x) => x.id);

    function isActiveDownloading() {
        return downloadingTrackIds.includes(currentTrack?.id ?? "");
    }

    function isFinishedDownloading() {
        return completedTrackIds.includes(currentTrack?.id ?? "");
    }

    useEffect(() => {
        downloadQueue.forEach(async (el) => {
            if (!completedTrackIds.includes(el.id)) {
                ytdl(el.youtube_uri, {
                    filter: "audioonly",
                })
                    .pipe(
                        fs.createWriteStream(
                            join(
                                os.homedir(),
                                "Music",
                                `${el.name} - ${el.artists
                                    .map((x) => x.name)
                                    .join(", ")
                                    .trim()}.mp3`,
                            ),
                        ),
                    )
                    .on("error", (err) => {
                        showError(err, `[failed to download ${el.name}]: `);
                    })
                    .on("finish", () => {
                        setCompletedQueue([...completedQueue, el]);
                    });
            }
        });
    }, [downloadQueue]);
    return { addToQueue, isFinishedDownloading, isActiveDownloading };
}

export default useDownloadQueue;
