import {
  Link as Anchor,
  Heading,
  VStack,
  chakra,
  Box,
  Flex,
  Stack,
  HStack,
  useColorModeValue,
} from "@chakra-ui/react";
import NavLink from "next/link";
// import { GridMultiplexAd } from "components/special";
import { GiBackwardTime } from "react-icons/gi";
import { FiPackage } from "react-icons/fi";
import { HiOutlineSparkles } from "react-icons/hi";
import { useRouter } from "next/router";
import { FC } from "react";

function OtherDownloads() {
  const router = useRouter();

  return (
    <>
      <Flex justify="center">
        <VStack my="20" mx="5" maxW="3xl" spacing="28">
          <VStack spacing="2" align="start">
            <Heading size="2xl">Other ways to install?</Heading>
            <Heading size="md">
              Here&apos;s some alternative ways & versions of Spotube that you
              can install try out
            </Heading>
          </VStack>
          <Stack direction={["column", null, "row"]} spacing="4">
            <OtherDownloadLinkItem
              href={"/package-manager"}
              icon={<FiPackage />}
            >
              Package Managers &amp; AppStores
            </OtherDownloadLinkItem>
            <OtherDownloadLinkItem
              href="/nightly-downloads"
              icon={<HiOutlineSparkles />}
              color={useColorModeValue("red.500", "red.200")}
              bgColor={useColorModeValue("red.100", "red.800")}
            >
              Nightly versions
            </OtherDownloadLinkItem>
            <OtherDownloadLinkItem
              href={"/stable-downloads"}
              icon={<GiBackwardTime />}
            >
              Previous versions
            </OtherDownloadLinkItem>
            &nbsp;(Nightly&nbsp;releases)
          </Stack>
        </VStack>
      </Flex>
      {/* <GridMultiplexAd slot="4575915852" /> */}
    </>
  );
}

export default OtherDownloads;

interface OtherDownloadLinkItemType {
  href: string;
  icon: React.ReactNode;
  color?: string;
  bgColor?: string;
  children: React.ReactNode;
}

const OtherDownloadLinkItem: FC<OtherDownloadLinkItemType> = ({
  href,
  icon,
  color,
  bgColor,
  children,
}) => {
  const router = useRouter();
  const dColor = useColorModeValue("blue.500", "blue.200");
  const dBColor = useColorModeValue("blue.100", "blue.800");

  return (
    <NavLink href={router.pathname + href} passHref style={{ width: "100%" }}>
      <Anchor color={color ?? dColor} w="100%">
        <Box
          w="100%"
          h="40"
          bgColor={bgColor ?? dBColor}
          display="flex"
          flexDirection="column"
          alignItems="center"
          justifyContent="center"
          p="5"
          borderRadius="lg"
          fontSize="1.2rem"
          textAlign="center"
        >
          <chakra.p mb="2" fontSize="4xl">
            {icon}
          </chakra.p>
          {children}
        </Box>
      </Anchor>
    </NavLink>
  );
};
