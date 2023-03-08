import {
  Accordion,
  AccordionButton,
  AccordionIcon,
  AccordionItem,
  AccordionPanel,
  Link as Anchor,
  Heading,
  HStack,
  Text,
  VStack,
  chakra,
} from "@chakra-ui/react";
import { Octokit, RestEndpointMethodTypes } from "@octokit/rest";
import ReactMarkdown from "react-markdown";
import { Platform } from "hooks/usePlatform";
import gfm from "remark-gfm";
// import { DisplayAd, InFeedAd } from "components/special";
import { GetServerSideProps, NextPage } from "next";
import { MarkdownComponentDefs } from "misc/MarkdownComponentDefs";
import { octokit } from "configurations/ocotokit";
import gemoji from "remark-gemoji";

enum AssetTypes {
  sums = "sums",
  linux = "linux",
  mac = "mac",
  windows = "windows",
  android = "android",
}

export type ReleaseResponse = {
  id: number;
  body: string | null | undefined;
  tag_name: string;
  assets: {
    id: number;
    name: string;
    browser_download_url: string;
  }[];
};

type Props = {
  data: ReleaseResponse[];
};

export const getServerSideProps: GetServerSideProps<Props> = async ({
  res,
}) => {
  res.setHeader(
    "Cache-Control",
    "public, s-maxage=10, stale-while-revalidate=59"
  );
  const { data } = await octokit.repos.listReleases({
    owner: "KRTirtho",
    repo: "spotube",
  });
  const releaseResponse: ReleaseResponse[] = data
    .map((data) => {
      return {
        tag_name: data.tag_name,
        id: data.id,
        body: data.body,
        assets: data.assets.map((asset) => ({
          id: asset.id,
          name: asset.name,
          browser_download_url: asset.browser_download_url,
        })),
      };
    })
    .filter((release) => release.tag_name !== "nightly");
  return {
    props: {
      data: releaseResponse,
    },
  };
};

const StableDownloads: NextPage<Props> = ({ data }) => {
  return (
    <VStack alignItems="center">
      <VStack alignItems="stretch" m="3">
        <Heading size="xl">Previous Versions</Heading>
        <Text my="5">
          If any of your version is not working correctly than you can download
          & use previous versions of Spotube too
        </Text>

        <VStack
          alignItems="flex-start"
          spacing="3"
          mr="1"
        >
          {data.map((release, i) => {
            const releaseSome = release.assets
              .map((asset) => {
                const platform =
                  Object.keys(Platform).find((platform) =>
                    asset.name.toLowerCase().includes(platform)
                  ) ?? "sums";
                return {
                  type: AssetTypes[platform as keyof typeof AssetTypes],
                  asset,
                };
              })
              .reduce((acc, val) => {
                acc[val.type] = [...(acc[val.type] ?? []), val.asset];
                return acc;
              }, {} as any) as {
              [key in AssetTypes]: RestEndpointMethodTypes["repos"]["listReleases"]["response"]["data"][0]["assets"];
            };
            return (
              <VStack key={release.id} py="3" w="full">
                <Heading size="md">
                  Version{" "}
                  <Text as="span" color="blue.500">
                    {release.tag_name}
                  </Text>{" "}
                  {i == 0 && "(Latest)"}
                </Heading>
                {Object.entries(releaseSome).map(([type, assets], i) => {
                  return (
                    <HStack
                      key={i}
                      spacing={0}
                      p="2"
                      alignItems="flex-start"
                      bgColor="gray.50"
                      _dark={{ bgColor: "gray.900" }}
                    >
                      <Heading
                        w={90}
                        p="2"
                        colorScheme="blue"
                        borderRadius="5px 0 0 5px"
                        borderRight="none"
                        size="sm"
                      >
                        {type[0].toUpperCase() + type.slice(1)}
                      </Heading>
                      <VStack
                        alignItems="flex-start"
                        w={{
                          base: "full",
                          sm: "72",
                        }}
                        spacing={2}
                      >
                        {assets.map((asset) => {
                          return (
                            <Anchor
                              key={asset.id}
                              color="blue.500"
                              width="full"
                              p="1.5"
                              href={asset.browser_download_url}
                              target="_blank"
                              referrerPolicy="no-referrer"
                              bgColor="gray.100"
                              _dark={{ bgColor: "gray.800" }}
                              borderRadius="md"
                            >
                              {asset.name}
                            </Anchor>
                          );
                        })}
                      </VStack>
                    </HStack>
                  );
                })}
                <Accordion defaultIndex={i} allowToggle>
                  <AccordionItem>
                    <AccordionButton>
                      Release Notes <AccordionIcon />
                    </AccordionButton>
                    <AccordionPanel>
                      <ReactMarkdown
                        components={MarkdownComponentDefs}
                        remarkPlugins={[gfm, gemoji]}
                      >
                        {release.body ?? ""}
                      </ReactMarkdown>
                    </AccordionPanel>
                  </AccordionItem>
                </Accordion>
              </VStack>
            );
          })}
        </VStack>
      </VStack>
    </VStack>
  );
};

export default StableDownloads;
