import { Anchor, Heading, VStack } from "@hope-ui/solid";
import { NavLink } from "solid-app-router";
import { GridMultiplexAd } from "../components/special";

function OtherDownloads() {
  return (
    <VStack alignItems="flex-start" ml="$10" mt="$20">
      <Heading size="2xl">Download other versions of Spotube</Heading>
      <ul>
        <li>
          <Anchor color="$info10" as={NavLink} href="/stable-downloads">
            Download previous versions of Spotube
          </Anchor>
        </li>
        <li>
          <Anchor color="$info10" as={NavLink} href="/nightly-downloads">
            Download Bleeding Edge Nightly version of Spotube
          </Anchor>{" "}
          (Nightly releases)
        </li>
      </ul>
      <GridMultiplexAd slot="4575915852" />
    </VStack>
  );
}

export default OtherDownloads;
