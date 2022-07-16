import {
  Heading,
  Menu,
  ButtonGroup,
  Button,
  Anchor,
  MenuTrigger,
  IconButton,
  MenuContent,
  MenuItem,
  VStack,
  hope,
} from "@hope-ui/solid";
import { FaSolidCaretDown } from "solid-icons/fa";
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

export const Root = () => {
  const platform = usePlatform();

  const allPlatforms = Object.entries(Platform)
    .map(([key, value]) => {
      return DownloadLinks[value].map((s) => ({
        ...s,
        name: `${value} (.${s.name})`,
      }));
    })
    .flat(1);

  const currentPlatform = DownloadLinks[platform][0];
  return (
    <VStack spacing="$4" alignItems="stretch">
      <hope.section
        h="60vh"
        backgroundColor="#f5f5f5"
        style={{
          "background-image": "url(/src/assets/spotube-screenshot-web.jpg)",
          "background-repeat": "no-repeat",
          "background-size": "contain",
          "background-position": "right",
        }}
      >
        <VStack mt="$10" mx="$6" spacing="$4" alignItems="flex-start">
          <Heading color="#212121" size="5xl">
            Spotube
          </Heading>
          <Heading color="#212121" size="2xl" textAlign="justify" maxW="500px">
            A fast, modern, lightweight & efficient Spotify Music Client for
            every platform
          </Heading>
          <Menu placement="bottom-end">
            <ButtonGroup spacing="$0_5">
              <Button
                variant="subtle"
                as={Anchor}
                href={currentPlatform.url}
                _hover={{ textDecoration: "none" }}
              >
                Download for {platform} (.{currentPlatform.name})
              </Button>
              <MenuTrigger as={IconButton} variant="subtle">
                <FaSolidCaretDown />
              </MenuTrigger>
            </ButtonGroup>
            <MenuContent>
              {allPlatforms.map(({ name, url }) => {
                return (
                  <MenuItem as={Anchor} href={url}>
                    {name}
                  </MenuItem>
                );
              })}
            </MenuContent>
          </Menu>
        </VStack>
      </hope.section>
      <DisplayAd slot="9501208974" />
    </VStack>
  );
};
