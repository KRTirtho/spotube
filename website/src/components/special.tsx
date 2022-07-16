import { Component, createEffect } from "solid-js";

type AdComponent = Component<{
  slot: string;
}>;

export const DisplayAd: AdComponent = ({ slot }) => {
  createEffect(() => {
    //@ts-ignore
    (window.adsbygoogle = window.adsbygoogle || []).push({});
  }, []);

  return (
    <ins
      class="adsbygoogle"
      style={{ display: "block" }}
      data-ad-client="ca-pub-6419300932495863"
      data-ad-slot={slot}
      data-ad-format="auto"
      data-full-width-responsive="true"
    ></ins>
  );
};

export const GridMultiplexAd: AdComponent = ({ slot }) => {
  createEffect(() => {
    //@ts-ignore
    (window.adsbygoogle = window.adsbygoogle || []).push({});
  }, []);

  return (
    <ins
      class="adsbygoogle"
      style={{ display: "block" }}
      data-ad-format="autorelaxed"
      data-ad-client="ca-pub-6419300932495863"
      data-ad-slot={slot}
    ></ins>
  );
};
