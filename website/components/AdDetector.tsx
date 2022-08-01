import {
  Button,
  CloseButton,
  Heading,
  Modal,
  ModalBody,
  ModalContent,
  ModalFooter,
  ModalHeader,
  ModalOverlay,
  Stack,
  Text,
  Tooltip,
  useDisclosure,
  VStack,
} from "@chakra-ui/react";
import { FC, ReactNode, useEffect, useState } from "react";

const AdDetector: FC<{ children: ReactNode }> = ({ children }) => {
  const [adBlockEnabled, setAdBlockEnabled] = useState(false);
  const { isOpen, onOpen, onClose } = useDisclosure();
  const [joke, setJoke] = useState<Record<string, any>>({});

  useEffect(() => {
    (async () => {
      const googleAdUrl =
        "https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js";
      try {
        await fetch(new Request(googleAdUrl));
      } catch (e) {
        setAdBlockEnabled(true);
        setJoke(
          await (
            await fetch(
              "https://v2.jokeapi.dev/joke/Any?blacklistFlags=racist,sexist"
            )
          ).json()
        );
        onOpen();
      }
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <>
      <Modal isOpen={isOpen} onClose={onClose}>
        <ModalOverlay />
        <ModalContent mt="5" mx="3">
          <ModalHeader>Support the Creator💚</ModalHeader>
          <ModalBody>
            <p>
              Open source developers work really hard to provide the best,
              secure & efficient software experience for you & people all around
              the world. Most of the time we work without any wages at all but
              we need minimum support to live & these <b> Ads Helps Us</b> earn
              the minimum wage that we need to live.{" "}
              <Text color="green.500" fontWeight="bold" textAlign="justify">
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
      {!adBlockEnabled ? (
        children
      ) : (
        <Stack
          direction="column"
          w="100vw"
          h="100vh"
          justifyContent="space-between"
          alignItems="center"
          p="5"
          pos="relative"
        >
          <Tooltip label="You made me sad 😢">
            <CloseButton
              pos="absolute"
              right="5"
              variant="ghost"
              onClick={() => setAdBlockEnabled(false)}
            />
          </Tooltip>
          <VStack spacing="2" alignItems="flex-start">
            <Heading size="sm">Here&apos;s something interesting:</Heading>
            <Heading size="md">
              {joke.joke ?? (
                <>
                  <p>{joke.setup}</p>
                  <p>{joke.delivery}</p>
                </>
              )}
            </Heading>
          </VStack>
          <VStack justifySelf="flex-end">
            <Heading
              mt="10"
              size={{
                base: "lg",
                lg: "xl",
              }}
              maxW="700px"
              textAlign="justify"
              lineHeight="1.5"
            >
              Be grateful for all the favors you get. But don&apos;t let it
              become a pile of debt. Try returning them as soon as you can.
              You&apos;ll feel relieved
            </Heading>
            <Heading
              size={{
                lg: "lg",
                base: "md",
              }}
              alignSelf="flex-end"
            >
              - Kingkor Roy Tirtho
            </Heading>
          </VStack>
        </Stack>
      )}
    </>
  );
};

export default AdDetector;
