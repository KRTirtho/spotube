import Script from "next/script";
import { FC, useId } from "react";

type AdComponent = FC<{
  slot: string;
}>;

export const DisplayAd: AdComponent = ({ slot }) => {
  const id = useId();
  return (
    <>
      <ins
        className="adsbygoogle"
        style={{ display: "block" }}
        data-ad-client={process.env.NEXT_PUBLIC_ADSENSE_ID}
        data-ad-slot={slot}
        data-ad-format="auto"
        data-full-width-responsive="true"
      ></ins>
      <Script
        id={id + "#" + slot}
        dangerouslySetInnerHTML={{
          __html: `(adsbygoogle = window.adsbygoogle || []).push({});`,
        }}
      ></Script>
    </>
  );
};

export const GridMultiplexAd: AdComponent = ({ slot }) => {
  const id = useId();
  return (
    <>
      <ins
        className="adsbygoogle"
        style={{ display: "block" }}
        data-ad-format="autorelaxed"
        data-ad-client={process.env.NEXT_PUBLIC_ADSENSE_ID}
        data-ad-slot={slot}
      ></ins>
      <Script
        id={id + "#" + slot}
        dangerouslySetInnerHTML={{
          __html: `(adsbygoogle = window.adsbygoogle || []).push({});`,
        }}
      ></Script>
    </>
  );
};

export const InFeedAd = () => {
  const id = useId();
  return (
    <>
      <ins
        className="adsbygoogle"
        style={{ display: "block" }}
        data-ad-format="fluid"
        data-ad-layout-key="-e5+6n-34-bt+x0"
        data-ad-client="ca-pub-6419300932495863"
        data-ad-slot="6460144484"
      ></ins>
      <Script
        id={id}
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `(adsbygoogle = window.adsbygoogle || []).push({});`,
        }}
      ></Script>
    </>
  );
};
