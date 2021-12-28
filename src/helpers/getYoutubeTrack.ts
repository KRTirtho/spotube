import { CurrentTrack } from "../context/playerContext";
import { Client, SearchResult } from "youtubei";
import { Logger } from "../initializations/logger";

const youtube = new Client();

/**
 * returns the percentage of matched elements of a certain array(src)
 * which is determined by checking if a the element is available in the
 * array or not
 * @author KR Tirtho
 * @param {(string | Array<string | number>)} src
 * @param {(Array<string | number>)} matches
 * @return {*}  {number}
 */
export function includePercentage(
    src: string | Array<string | number>,
    matches: Array<string | number>,
): number {
    let count = 0;
    matches.forEach((match) => {
        if (src.includes(match.toString())) count++;
    });
    return (count / matches.length) * 100;
}

export interface YoutubeTrack extends CurrentTrack {
    youtube_uri: string;
}

const logger = new Logger("GetYoutubeTrack");

export async function getYoutubeTrack(
    track: SpotifyApi.TrackObjectFull,
): Promise<YoutubeTrack> {
    try {
        const artistsName = track.artists.map((ar) => ar.name);
        const queryString = `${artistsName[0]} - ${track.name}${
            artistsName.length > 1 ? ` feat. ${artistsName.slice(1).join(" ")}` : ``
        }`;
        logger.info(`Youtube Query String: ${queryString}`);
        const result = (await youtube.search(queryString, {
            type: "video",
        })) as SearchResult<"video">;
        const tracksWithRelevance = result
            .map((video) => {
                // percentage of matched track {name, artists} matched with
                // title of the youtube search results
                const matchPercentage = includePercentage(video.title, [
                    track.name,
                    ...artistsName,
                ]);
                // keeps only those tracks which are from the same artist channel
                const sameChannel =
                    video.channel?.name.includes(artistsName[0]) ||
                    (video.channel && artistsName[0].includes(video.channel.name));
                return {
                    url: `http://www.youtube.com/watch?v=${video.id}`,
                    matchPercentage,
                    sameChannel,
                    id: track.id,
                };
            })
            .sort((a, b) => (a.matchPercentage > b.matchPercentage ? -1 : 1));
        const sameChannelTracks = tracksWithRelevance.filter((tr) => tr.sameChannel);

        const rarestTrack = result.map((res) => ({
            url: `http://www.youtube.com/watch?v=${res.id}`,
            id: res.id,
        }));

        const finalTrack = {
            ...track,
            youtube_uri: (sameChannelTracks.length > 0
                ? sameChannelTracks
                : tracksWithRelevance.length > 0
                ? tracksWithRelevance
                : rarestTrack)[0].url,
        };
        return finalTrack;
    } catch (error: any) {
        logger.error(error);
        throw error;
    }
}
