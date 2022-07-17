import { Link as Anchor, Heading, VStack, chakra } from "@chakra-ui/react";
import NavLink from "next/link";
import { GridMultiplexAd } from "components/special";
import { useRouter } from "next/router";

function OtherDownloads() {
  const router = useRouter();

  return (
    <>
      <VStack my="20" mx="5">
        <Heading size="lg">Download other versions of Spotube</Heading>
        <chakra.ul pl="5">
          <li>
            <NavLink href={router.pathname + "/stable-downloads"} passHref>
              <Anchor color="blue.500">
                Download previous versions of Spotube
              </Anchor>
            </NavLink>
          </li>
          <li>
            <NavLink href={router.pathname + "/nightly-downloads"} passHref>
              <Anchor color="blue.500">
                Download Bleeding Edge Nightly version of Spotube
              </Anchor>
            </NavLink>
            &nbsp;(Nightly&nbsp;releases)
          </li>
        </chakra.ul>
      </VStack>
      <GridMultiplexAd slot="4575915852" />
    </>
  );
}

export default OtherDownloads;
