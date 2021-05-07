import axios from "axios";
import htmlToText from "html-to-text";
import showError from "./showError";
const delim1 = '</div></div></div></div><div class="hwc"><div class="BNeawe tAd8D AP7Wnd"><div><div class="BNeawe tAd8D AP7Wnd">';
const delim2 = '</div></div></div></div></div><div><span class="hwc"><div class="BNeawe uEec3 AP7Wnd">';
const url = "https://www.google.com/search?q=";

export default async function fetchLyrics(artists: string, title: string) {
  let lyrics;
  try {
    console.log("[lyric query]:", `${url}${encodeURIComponent(title + " " + artists)}+lyrics`);
    lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+lyrics`, { responseType: "text" })).data;
    [, lyrics] = lyrics.split(delim1);
    [lyrics] = lyrics.split(delim2);
  } catch (err) {
    showError(err, "[Lyric Query Error]: ");
    try {
      console.log("[lyric query]:", `${url}${encodeURIComponent(title + " " + artists)}+song+lyrics`);
      lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+song+lyrics`)).data;
      [, lyrics] = lyrics.split(delim1);
      [lyrics] = lyrics.split(delim2);
    } catch (err_1) {
      showError(err_1, "[Lyric Query Error]: ");
      try {
        console.log("[lyric query]:", `${url}${encodeURIComponent(title + " " + artists)}+song`);
        lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}+song`)).data;
        [, lyrics] = lyrics.split(delim1);
        [lyrics] = lyrics.split(delim2);
      } catch (err_2) {
        showError(err_2, "[Lyric Query Error]: ");
        try {
          console.log("[lyric query]:", `${url}${encodeURIComponent(title + " " + artists)}`);
          lyrics = (await axios.get<string>(`${url}${encodeURIComponent(title + " " + artists)}`)).data;
          [, lyrics] = lyrics.split(delim1);
          [lyrics] = lyrics.split(delim2);
        } catch (err_3) {
          showError(err_3, "[Lyric Query Error]: ");
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
