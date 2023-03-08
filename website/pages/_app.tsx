import "../styles/globals.css";
import type { AppProps } from "next/app";
import {
  ChakraProvider,
  extendTheme,
  withDefaultColorScheme,
} from "@chakra-ui/react";
import Navbar from "components/Navbar";
import { chakra } from "@chakra-ui/react";
import { mode } from "@chakra-ui/theme-tools";
import Head from "next/head";
import { useRouter } from "next/router";
// import Script from "next/script";
// import * as gtag from "configurations/gtag";
// import AdDetector from "components/AdDetector";
import Footer from "components/Footer";
import NextNProgress from "nextjs-progressbar";

const customTheme = extendTheme(
  { 
    initialColorMode: 'system',
    useSystemColorMode: true,
    styles: {
      global: (props: any) => ({
        body: {
          bg: mode("white", "#171717")(props),
        },
      }),
    },
    colors: {
      blue: {
        50: "#e6f2ff",
        100: "#e6f2ff",
        200: "#e6f2ff",
        300: "#1681bd",
        400: "#1681bd",
        500: "#3a4da5",
        600: "#2d3c7d",
        700: "#1f2b55",
        800: "#121c2e",
        900: "#080e18",
      },
      components: {
        Link: {
          baseStyle: {
            color: "blue",
          },
        },
      },
    },
  },
  withDefaultColorScheme({ colorScheme: "blue" })
);

function MyApp({ Component, pageProps }: AppProps) {
  const router = useRouter();
  // useEffect(() => {
  //   const handleRouteChange = (url: string) => {
  //     gtag.pageview(url);
  //   };
  //   router.events.on("routeChangeComplete", handleRouteChange);
  //   router.events.on("hashChangeComplete", handleRouteChange);
  //   return () => {
  //     router.events.off("routeChangeComplete", handleRouteChange);
  //     router.events.off("hashChangeComplete", handleRouteChange);
  //   };
  // }, [router.events]);

  return (
    <>
      {/* <Script
        async
        onError={(e) => {
          console.error("Script failed to load", e);
        }}
        src={`https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${process.env.NEXT_PUBLIC_ADSENSE_ID}`}
        crossOrigin="anonymous"
      /> */}
      {/* Global Site Tag (gtag.js) - Google Analytics */}
      {/* <Script
        strategy="afterInteractive"
        src={`https://www.googletagmanager.com/gtag/js?id=${gtag.GA_TRACKING_ID}`}
      /> */}
      {/* <Script
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
      /> */}
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
        <NextNProgress color="#00a7a4" />
        <chakra.div
          minH="100vh"
          display="flex"
          flexDir="column"
          justifyContent="space-between"
        >
          <div>
            <Navbar />
            <Component {...pageProps} />
          </div>
          <Footer />
        </chakra.div>
      </ChakraProvider>
    </>
  );
}

export default MyApp;
