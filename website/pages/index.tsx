import {
  Heading,
  Menu,
  ButtonGroup,
  Button,
  IconButton,
  MenuItem,
  VStack,
  MenuButton,
  Link as Anchor,
  chakra,
  MenuList,
} from "@chakra-ui/react";
import { FaCaretDown } from "react-icons/fa";
import { DisplayAd } from "../components/special";
import { Platform, usePlatform } from "../hooks/usePlatform";

const baseURL = "https://github.com/KRTirtho/spotube/releases/latest/download/";

const DownloadLinks = Object.freeze({
  [Platform.linux]: [
    { name: "deb", url: baseURL + "Spotube-linux-x86_64.deb" },
    { name: "tar", url: baseURL + "Spotube-linux-x86_64.tar.xz" },
    { name: "AppImage", url: baseURL + "Spotube-linux-x86_64.AppImage" },
  ],
  [Platform.android]: [
    {
      name: "apk",
      url: baseURL + "Spotube-android-all-arch.apk",
    },
  ],
  [Platform.mac]: [{ name: "dmg", url: baseURL + "Spotube-macos-x86_64.dmg" }],
  [Platform.windows]: [
    { name: "exe", url: baseURL + "Spotube-windows-x86_64-setup.exe" },
    { name: "nupkg", url: baseURL + "Spotube-windows-x86_64.nupkg " },
  ],
});

const Root = () => {
  const platform = usePlatform();

  const allPlatforms = Object.entries(Platform)
    .map(([, value]) => {
      return DownloadLinks[value].map((s) => ({
        ...s,
        name: `${value} (.${s.name})`,
      }));
    })
    .flat(1);

  const currentPlatform = DownloadLinks[platform][0];
  return (
    <>
      <VStack spacing="$4" alignItems="stretch">
        <chakra.section
          h="60vh"
          bgColor="#f5f5f5"
          bgImage="url(/spotube-screenshot-web.jpg)"
          bgRepeat="no-repeat"
          bgSize="contain"
          bgPos="right"
        >
          <VStack mt="10" mx="6" spacing="4" alignItems="flex-start">
            <Heading color="#212121" size="2xl">
              Spotube
            </Heading>
            <Heading color="#212121" size="lg" textAlign="justify" maxW="500px">
              A fast, modern, lightweight & efficient Spotify Music Client for
              every platform
            </Heading>
            <Menu placement="bottom-end">
              <ButtonGroup spacing="0.5">
                <Button
                  variant="solid"
                  as={Anchor}
                  href={currentPlatform.url}
                  _hover={{ textDecoration: "none" }}
                >
                  Download for {platform} (.{currentPlatform.name})
                </Button>
                <MenuButton
                  aria-label="Show More Downloads"
                  as={IconButton}
                  variant="solid"
                  icon={<FaCaretDown />}
                />
              </ButtonGroup>
              <MenuList>
                {allPlatforms.map(({ name, url }) => {
                  return (
                    <MenuItem key={url} as={Anchor} href={url}>
                      {name}
                    </MenuItem>
                  );
                })}
              </MenuList>
            </Menu>
          </VStack>
        </chakra.section>
        <DisplayAd slot="9501208974" />
      </VStack>
    </>
  );
};

export default Root;
