import {
  Button,
  createDisclosure,
  Heading,
  Modal,
  ModalBody,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  Stack,
  Text,
  VStack,
} from "@hope-ui/solid";
import {
  Component,
  createEffect,
  createResource,
  createSignal,
} from "solid-js";
import Navbar from "./components/Navbar";
import { Route, Router, Routes } from "solid-app-router";
import { Root } from "./pages/Root";
import OtherDownloads from "./pages/OtherDownloads";
import NightlyDownloads from "./pages/NightlyDownloads";
import StableDownloads from "./pages/StableDownloads";

const App: Component = () => {
  const [adBlockEnabled, setAdBlockEnabled] = createSignal(false);
  const { isOpen, onOpen, onClose } = createDisclosure();
  const [joke, setJoke] = createSignal<Record<string, any>>({});

  createEffect(() => {
    (async () => {
      const googleAdUrl =
        "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js";
      try {
        await fetch(new Request(googleAdUrl)).catch((_) =>
          setAdBlockEnabled(true)
        );
      } catch (e) {
        setAdBlockEnabled(true);
      } finally {
        if (adBlockEnabled()) {
          setJoke(
            await (
              await fetch(
                "https://v2.jokeapi.dev/joke/Any?blacklistFlags=racist,sexist"
              )
            ).json()
          );
          onOpen();
        }
      }
    })();
  }, []);

  return (
    <Router>
      <Modal opened={isOpen()} onClose={onClose}>
        <ModalOverlay />
        <ModalContent mt="$5" mx="$3">
          <ModalHeader>Support the Creator💚</ModalHeader>
          <ModalBody>
            <p>
              Open source developers work really hard to provide the best,
              secure & efficient software experience for you & people all around
              the world. Most of the time we work without any wages at all but
              we need minimum support to live & these <b> Ads Helps Us</b> earn
              the minimum wage that we need to live.{" "}
              <Text color="$success10" fontWeight="bold" textAlign="justify">
                So, please support Spotube by disabling the AdBlocker on this
                page or by sponsoring or donating to our collectives directly
              </Text>
            </p>
          </ModalBody>
          <ModalFooter>
            <Button onClick={() => window.location.reload()}>
              Reload without AdBlocker
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
      {!adBlockEnabled() ? (
        <VStack alignItems="stretch">
          <Navbar />
          <Routes>
            <Route path="/" component={Root} />
            <Route path="/other-downloads" component={OtherDownloads} />
            <Route path="/stable-downloads" component={StableDownloads} />
            <Route path="/nightly-downloads" component={NightlyDownloads} />
          </Routes>
        </VStack>
      ) : (
        <Stack
          direction="column"
          w="100vw"
          h="100vh"
          justifyContent="space-between"
          alignItems="center"
          p="$5"
        >
          <Heading></Heading>
          <VStack spacing="$2" alignItems="flex-start">
            <Heading>Here's something interesting:</Heading>
            <Heading size="xl">
              {joke().joke ?? (
                <>
                  <p>{joke().setup}</p>
                  <p>{joke().delivery}</p>
                </>
              )}
            </Heading>
          </VStack>
          <VStack justifySelf="flex-end">
            <Heading
              mt="$10"
              size={{
                "@lg": "4xl",
                "@initial": "2xl",
              }}
              maxW="700px"
              textAlign="justify"
              lineHeight="1.5"
            >
              Be grateful for all the favors you get. But don't let it become a
              pile of debt. Try returning them as soon as you can. You'll feel
              relieved
            </Heading>
            <Heading
              size={{
                "@lg": "2xl",
                "@initial": "lg",
              }}
              alignSelf="flex-end"
            >
              - Kingkor Roy Tirtho
            </Heading>
          </VStack>
        </Stack>
      )}
    </Router>
  );
};

export default App;
