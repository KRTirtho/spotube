import { createEffect } from "solid-js";

export function DisplayAd() {
  createEffect(() => {
    //@ts-ignore
    (window.adsbygoogle = window.adsbygoogle || []).push({});
  }, []);

  return (
    <ins
      class="adsbygoogle"
      style={{ display: "block" }}
      data-ad-client="ca-pub-6419300932495863"
      data-ad-slot="9501208974"
      data-ad-format="auto"
      data-full-width-responsive="true"
    ></ins>
  );
}
