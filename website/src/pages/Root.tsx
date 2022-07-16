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
} from "@hope-ui/solid";
import { FaSolidCaretDown } from "solid-icons/fa";
import { Platform, usePlatform } from "../hooks/usePlatform";

const baseURL = "https://github.com/KRTirtho/spotube/releases/latest/download/";

const DownloadLinks = {
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
};

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
    <VStack alignSelf="center" spacing="$4">
      <Heading size="5xl">Spotube</Heading>
      <Heading size="2xl">
        A fast, modern, lightweight & efficient Spotify Music Client for every
        platform
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
  );
};
