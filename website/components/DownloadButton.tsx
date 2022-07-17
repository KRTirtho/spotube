import {
  Menu,
  ButtonGroup,
  Button,
  MenuButton,
  IconButton,
  MenuList,
  MenuItem,
  Link as Anchor,
} from "@chakra-ui/react";
import { Platform, usePlatform } from "hooks/usePlatform";
import React from "react";
import { FaCaretDown } from "react-icons/fa";

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

const DownloadButton = () => {
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
  );
};

export default DownloadButton;
