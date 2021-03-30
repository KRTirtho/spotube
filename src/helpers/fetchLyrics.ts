
import axios from 'axios';
import htmlToText from 'html-to-text';
const delim1 = '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
const delim2 = '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';
const url = "https://www.google.com/search?q=";

export default async function fetchLyrics(artists:string, title: string) {
    let lyrics;
    try {
        lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+lyrics`, {responseType: "text"})).data;
        [, lyrics] = lyrics.split(delim1);
        [lyrics] = lyrics.split(delim2);
    } catch (m) {
        try {
            lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+song+lyrics`)).data;
            [, lyrics] = lyrics.split(delim1);
            [lyrics] = lyrics.split(delim2);
        } catch (n) {
            try {
                lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+song`)).data;
                [, lyrics] = lyrics.split(delim1);
                [lyrics] = lyrics.split(delim2);
            } catch (o) {
                try {
                    lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}`)).data;
                    [, lyrics] = lyrics.split(delim1);
                    [lyrics] = lyrics.split(delim2);
                } catch (p) {
                    lyrics = 'Not Found';
                }
            }
        }
    }
    const rets = lyrics.split('\n');
    let final = '';
    for (const ret of rets) {
        final = `${final}${htmlToText.htmlToText(ret)}\n`;
    }
    return final.trim();
}