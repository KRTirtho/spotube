import axios from "axios";
import htmlToText from "html-to-text";
import { Logger } from "../initializations/logger";
const delim1 =
    '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
const delim2 =
    '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';
const url = "https://www.google.com/search?q=";

const logger = new Logger("FetchLyrics");

export default async function fetchLyrics(artists: string, title: string) {
    let lyrics;
    try {
        logger.info(
            "Lyric Query",
            `${url}${encodeURIComponent(title + " " + artists)}+lyrics`,
        );
        lyrics = (
            await axios.get<string>(
                `${url}${encodeURIComponent(title + " " + artists)}+lyrics`,
                { responseType: "text" },
            )
        ).data;
        [, lyrics] = lyrics.split(delim1);
        [lyrics] = lyrics.split(delim2);
    } catch (err: any) {
        logger.error("Lyric Query Error", err);
        try {
            logger.info(
                "Lyric Query",
                `${url}${encodeURIComponent(title + " " + artists)}+song+lyrics`,
            );
            lyrics = (
                await axios.get<string>(
                    `${url}${encodeURIComponent(title + " " + artists)}+song+lyrics`,
                )
            ).data;
            [, lyrics] = lyrics.split(delim1);
            [lyrics] = lyrics.split(delim2);
        } catch (err_1: any) {
            logger.error("Lyric Query Error", err_1);
            try {
                logger.info(
                    "Lyric Query",
                    `${url}${encodeURIComponent(title + " " + artists)}+song`,
                );
                lyrics = (
                    await axios.get<string>(
                        `${url}${encodeURIComponent(title + " " + artists)}+song`,
                    )
                ).data;
                [, lyrics] = lyrics.split(delim1);
                [lyrics] = lyrics.split(delim2);
            } catch (err_2: any) {
                logger.error("Lyric Query Error", err_2);
                try {
                    logger.info(
                        "Lyric Query",
                        `${url}${encodeURIComponent(title + " " + artists)}`,
                    );
                    lyrics = (
                        await axios.get<string>(
                            `${url}${encodeURIComponent(title + " " + artists)}`,
                        )
                    ).data;
                    [, lyrics] = lyrics.split(delim1);
                    [lyrics] = lyrics.split(delim2);
                } catch (err_3: any) {
                    logger.error("Lyric Query Error", err_3);
                    lyrics = "Not Found";
                }
            }
        }
    }
    const rets = lyrics.split("\n");
    let final = "";
    for (const ret of rets) {
        final = `${final}${htmlToText.htmlToText(ret)}\n`;
    }
    return final.trim();
}
