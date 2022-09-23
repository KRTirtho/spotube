import {
  Link as Anchor,
  Heading,
  VStack,
  chakra,
  Box,
  Flex,
} from "@chakra-ui/react";
import NavLink from "next/link";
// import { GridMultiplexAd } from "components/special";
import { useRouter } from "next/router";

function OtherDownloads() {
  const router = useRouter();

  return (
    <>
      <Flex justify="center">
        <VStack my="20" mx="5" maxW="3xl" align="start" spacing="10">
          <VStack spacing="2" align="start">
            <Heading size="2xl">Looking for Something else?</Heading>
            <Heading size="md">
              Here&apos;s some alternative ways & versions of Spotube that you
              can install try out
            </Heading>
          </VStack>
          <chakra.ul pl="5">
            <li>
              <NavLink href={router.pathname + "/package-manager"} passHref>
                <Anchor fontSize="2xl" color="blue.500">
                  Install Spotube via Package Managers or AppStores
                </Anchor>
              </NavLink>
            </li>
            <li>
              <NavLink href={router.pathname + "/stable-downloads"} passHref>
                <Anchor fontSize="2xl" color="blue.500">
                  Download previous versions of Spotube
                </Anchor>
              </NavLink>
            </li>
            <li>
              <NavLink href={router.pathname + "/nightly-downloads"} passHref>
                <Anchor color="blue.500" fontSize="2xl">
                  Download Bleeding Edge Nightly version of Spotube
                </Anchor>
              </NavLink>
              &nbsp;(Nightly&nbsp;releases)
            </li>
          </chakra.ul>
        </VStack>
      </Flex>
      {/* <GridMultiplexAd slot="4575915852" /> */}
    </>
  );
}

export default OtherDownloads;
