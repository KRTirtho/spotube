import {
  Link as Anchor,
  Button,
  Heading,
  Table,
  Td,
  Th,
  VStack,
  chakra,
  Text,
  Tr,
  HStack,
} from "@chakra-ui/react";
import { GridMultiplexAd } from "components/special";
import NavLink from "next/link";

const baseURL =
  "https://nightly.link/KRTirtho/spotube/workflows/spotube-nightly/build/";

const DownloadLinks = Object.freeze({
  Linux: baseURL + "Spotube-Linux-Bundle.zip",
  Android: baseURL + "Spotube-Android-Bundle.zip",
  Windows: baseURL + "Spotube-Windows-Bundle.zip",
  MacOS: baseURL + "Spotube-Macos-Bundle.zip",
});

function NightlyDownloads() {
  return (
    <>
      <VStack>
        <VStack
          alignSelf="center"
          alignItems="flex-start"
          spacing="4"
          maxW="500px"
          overflow="auto"
          m="5"
        >
          <Heading size="2xl">Nightly Release</Heading>
          <Text>Download latest & most bleeding edge version of Spotube</Text>
          <Text size="sm" color="red.500" textAlign="justify">
            Disclaimer!: Nightly versions are untested and not the final version
            of spotube. So it can consists of many hidden or unknown bugs but at
            the same time will be opted with latest & greatest features too. So
            use it at your own risk! If you don&apos;t know what you&apos;re
            doing than we recommend you to download the{" "}
            <NavLink href="/" passHref>
              <Anchor color="blue.500">latest stable version of</Anchor>
            </NavLink>{" "}
            Spotube
          </Text>
          <chakra.section
            border="2px solid"
            borderColor="gray"
            borderRadius="md"
            px="4"
            py="2"
            w="100%"
          >
            {Object.entries(DownloadLinks).map(([platform, url]) => {
              const segments = url.split("/");
              return (
                <HStack key={url}>
                  <Text w="100px">{platform}</Text>
                  <Anchor
                    overflowWrap="break-word"
                    wordBreak="break-word"
                    w="full"
                    href={url}
                    color="blue.500"
                  >
                    {segments.at(segments.length - 1)?.replace("build", "")}
                  </Anchor>
                </HStack>
              );
            })}
          </chakra.section>
        </VStack>
        <chakra.div w="full">
          <GridMultiplexAd slot="3192619797" />
        </chakra.div>
      </VStack>
    </>
  );
}

export default NightlyDownloads;
