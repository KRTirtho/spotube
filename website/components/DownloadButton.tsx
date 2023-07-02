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
import {
  FaApple,
  FaCaretDown,
  FaUbuntu,
  FaLinux,
  FaWindows,
  FaAndroid,
} from "react-icons/fa";
import { MdOutlineFileDownload } from "react-icons/md";

const baseURL = "https://github.com/KRTirtho/spotube/releases/latest/download/";

const DownloadLinks = Object.freeze({
  [Platform.linux]: [
    {
      name: "deb",
      url: baseURL + "Spotube-linux-x86_64.deb",
      icon: <FaUbuntu />,
    },
    {
      name: "tar",
      url: baseURL + "Spotube-linux-x86_64.tar.xz",
      icon: <FaLinux />,
    },
    {
      name: "AppImage",
      url: baseURL + "Spotube-linux-x86_64.AppImage",
      icon: <FaLinux />,
    },
  ],
  [Platform.android]: [
    {
      name: "apk",
      url: baseURL + "Spotube-android-all-arch.apk",
      icon: <FaAndroid />,
    },
  ],
  [Platform.mac]: [
    {
      name: "dmg",
      url: baseURL + "Spotube-macos-universal.dmg",
      icon: <FaApple />,
    },
  ],
  [Platform.windows]: [
    {
      name: "exe",
      url: baseURL + "Spotube-windows-x86_64-setup.exe",
      icon: <FaWindows />,
    },
    {
      name: "nupkg",
      url: baseURL + "Spotube-windows-x86_64.nupkg ",
      icon: <FaWindows />,
    },
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
          leftIcon={
            <MdOutlineFileDownload fontSize="24"/>
          }
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
        {allPlatforms.map(({ name, url, icon }) => {
          return (
            <MenuItem key={url} as={Anchor} href={url} icon={icon}>
              {name}
            </MenuItem>
          );
        })}
      </MenuList>
    </Menu>
  );
};

export default DownloadButton;
