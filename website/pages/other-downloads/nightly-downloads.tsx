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
import { octokit } from "configurations/ocotokit";
import { GetServerSideProps, NextPage } from "next";
// import { GridMultiplexAd } from "components/special";
import NavLink from "next/link";
import { ReleaseResponse } from "./stable-downloads";

type NightlyProps = ReleaseResponse;

export const getServerSideProps: GetServerSideProps<
  NightlyProps
> = async () => {
  const { data } = await octokit.repos.getReleaseByTag({
    owner: "KRTirtho",
    repo: "spotube",
    tag: "nightly",
  });
  return {
    props: {
      tag_name: data.tag_name,
      id: data.id,
      body: data.body,
      assets: data.assets.map((asset) => ({
        id: asset.id,
        name: asset.name,
        browser_download_url: asset.browser_download_url,
      })),
    },
  };
};

const NightlyDownloads: NextPage<NightlyProps> = (props) => {
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
          <VStack
            p="2"
            w="100%"
            borderRadius="md"
            spacing="4"
            bgColor="gray.50"
            _dark={{ bgColor: "gray.900" }}
          >
            {Object.entries(props.assets).map(
              ([_, { name, id, browser_download_url }], i) => {
                const segments = name.split("-");
                const platform = segments[1];
                const executable = segments[segments.length - 1].split(".")[1];
                return (
                  <HStack
                    key={id}
                    p="4"
                    w="100%"
                    borderRadius="md"
                    bgColor="gray.100"
                    _dark={{ bgColor: "gray.800" }}
                  >
                    <Text w="200px" textTransform="capitalize">
                      {platform}{" "}
                      <chakra.span color="gray.500">({executable})</chakra.span>
                    </Text>
                    <Anchor
                      overflowWrap="break-word"
                      wordBreak="break-word"
                      w="full"
                      href={browser_download_url}
                      color="blue.500"
                    >
                      {name}
                    </Anchor>
                  </HStack>
                );
              }
            )}
          </VStack>
        </VStack>
        <chakra.div w="full">
          {/* <GridMultiplexAd slot="3192619797" /> */}
        </chakra.div>
      </VStack>
    </>
  );
};

export default NightlyDownloads;
