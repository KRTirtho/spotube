import "../styles/globals.css";
import type { AppProps } from "next/app";
import {
  ChakraProvider,
  extendTheme,
  withDefaultColorScheme,
} from "@chakra-ui/react";
import Navbar from "components/Navbar";
import { mode } from "@chakra-ui/theme-tools";
import Head from "next/head";
import Script from "next/script";
import * as gtag from "configurations/gtag";
import { useRouter } from "next/router";
import { useEffect } from "react";
import AdDetector from "components/AdDetector";
import Footer from "components/Footer";

const customTheme = extendTheme(
  {
    styles: {
      global: (props: any) => ({
        body: {
          bg: mode("white", "#171717")(props),
        },
      }),
    },
    colors: {
      green: {
        50: "#d4f3df",
        100: "#b7ecca",
        200: "#9be4b4",
        300: "#61d48a",
        400: "#45cd74",
        500: "#32ba62",
        600: "#2b9e53",
        700: "#238144",
        800: "#1b6435",
        900: "#134826",
      },
      components: {
        Link: {
          baseStyle: {
            color: "green",
          },
        },
      },
    },
  },
  withDefaultColorScheme({ colorScheme: "green" })
);

function MyApp({ Component, pageProps }: AppProps) {
  const router = useRouter();
  useEffect(() => {
    const handleRouteChange = (url: string) => {
      gtag.pageview(url);
    };
    router.events.on("routeChangeComplete", handleRouteChange);
    router.events.on("hashChangeComplete", handleRouteChange);
    return () => {
      router.events.off("routeChangeComplete", handleRouteChange);
      router.events.off("hashChangeComplete", handleRouteChange);
    };
  }, [router.events]);

  return (
    <>
      <Script
        async
        onError={(e) => {
          console.error("Script failed to load", e);
        }}
        src={`https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${process.env.NEXT_PUBLIC_ADSENSE_ID}`}
        crossOrigin="anonymous"
      />
      {/* Global Site Tag (gtag.js) - Google Analytics */}
      <Script
        strategy="afterInteractive"
        src={`https://www.googletagmanager.com/gtag/js?id=${gtag.GA_TRACKING_ID}`}
      />
      <Script
        id="gtag-init"
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '${gtag.GA_TRACKING_ID}', {
              page_path: window.location.pathname,
            });
          `,
        }}
      />
      <ChakraProvider theme={customTheme}>
        <Head>
          <link
            rel="apple-touch-icon"
            sizes="180x180"
            href="/apple-touch-icon.png"
          />
          <link
            rel="icon"
            type="image/png"
            sizes="32x32"
            href="/favicon-32x32.png"
          />
          <link
            rel="icon"
            type="image/png"
            sizes="16x16"
            href="/favicon-16x16.png"
          />
          <link rel="manifest" href="/site.webmanifest" />
          <title>Spotube</title>
        </Head>
        <AdDetector>
          <Navbar />
          <Component {...pageProps} />
          <Footer />
        </AdDetector>
      </ChakraProvider>
    </>
  );
}

export default MyApp;
