import {
  Anchor,
  Button,
  Heading,
  Table,
  Td,
  Th,
  Tr,
  VStack,
  hope,
  Text,
} from "@hope-ui/solid";
import { NavLink } from "solid-app-router";
import { GridMultiplexAd } from "../components/special";

const baseURL =
  "https://nightly.link/KRTirtho/spotube/workflows/spotube-nightly/build";

const DownloadLinks = Object.freeze({
  Linux: baseURL + "Spotube-Linux-Bundle.zip",
  Android: baseURL + "Spotube-Android-Bundle.zip",
  Windows: baseURL + "Spotube-Windows-Bundle.zip",
  MacOS: baseURL + "Spotube-Macos-Bundle.zip",
});

function NightlyDownloads() {
  return (
    <VStack
      mx="$3"
      alignSelf="center"
      alignItems="flex-start"
      spacing="$4"
      maxW="500px"
      overflow="auto"
    >
      <Heading size="2xl">Nightly Release</Heading>
      <Text>Download latest & most bleeding edge version of Spotube</Text>
      <Text size="sm" color="$danger11" textAlign="justify">
        Disclaimer!: Nightly versions are untested and not the final version of
        spotube. So it can consists of many hidden or unknown bugs but at the
        same time will be opted with latest & greatest features too. So use it
        at your own risk! If you don't know what you're doing than we recommend
        you to download the{" "}
        <Anchor as={NavLink} color="$info10" href="/">
          latest stable version of
        </Anchor>{" "}
        Spotube
      </Text>
      <hope.section
        border="2px solid"
        borderColor="$neutral10"
        borderRadius="$md"
      >
        <Table overflow="auto">
          {Object.entries(DownloadLinks).map(([platform, url]) => {
            const segments = url.split("/");
            return (
              <Tr>
                <Th>{platform}</Th>
                <Td>
                  <Button as={Anchor} href={url} variant="ghost">
                    {segments.at(segments.length - 1)?.replace("build", "")}
                  </Button>
                </Td>
              </Tr>
            );
          })}
        </Table>
      </hope.section>
      <GridMultiplexAd slot="3192619797" />
    </VStack>
  );
}

export default NightlyDownloads;
