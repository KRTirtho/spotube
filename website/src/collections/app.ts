import type { IconType } from "react-icons";
import {
  FaAndroid,
  FaApple,
  FaDebian,
  FaFedora,
  FaOpensuse,
  FaUbuntu,
  FaWindows,
  FaRedhat,
  FaLinux,
} from "react-icons/fa6";
import { LuHouse, LuNewspaper, LuDownload, LuBook } from "react-icons/lu";

export const routes: Record<string, [string, IconType | null]> = {
  "/": ["Home", LuHouse],
  "/blog": ["Blog", LuNewspaper],
  "/docs": ["Docs", LuBook],
  "/downloads": ["Downloads", LuDownload],
  "/about": ["About", null],
};

const releasesUrl =
  "https://github.com/KRTirtho/Spotube/releases/latest/download";

export const downloadLinks: Record<string, [string, IconType[]]> = {
  "Android Apk": [`${releasesUrl}/Spotube-android-all-arch.apk`, [FaAndroid]],
  "Windows Executable": [
    `${releasesUrl}/Spotube-windows-x86_64-setup.exe`,
    [FaWindows],
  ],
  "macOS Dmg": [`${releasesUrl}/Spotube-macos-universal.dmg`, [FaApple]],
  "Ubuntu, Debian": [
    `${releasesUrl}/Spotube-linux-x86_64.deb`,
    [FaUbuntu, FaDebian],
  ],
  "Fedora, Redhat, Opensuse": [
    `${releasesUrl}/Spotube-linux-x86_64.rpm`,
    [FaFedora, FaRedhat, FaOpensuse],
  ],
  "iPhone Ipa": [`${releasesUrl}/Spotube-iOS.ipa`, [FaApple]],
};

export const extendedDownloadLinks: Record<
  string,
  [string, IconType[], string]
> = {
  Android: [`${releasesUrl}/Spotube-android-all-arch.apk`, [FaAndroid], "apk"],
  Windows: [
    `${releasesUrl}/Spotube-windows-x86_64-setup.exe`,
    [FaWindows],
    "exe",
  ],
  macOS: [`${releasesUrl}/Spotube-macos-universal.dmg`, [FaApple], "dmg"],
  "Ubuntu, Debian (x64)": [
    `${releasesUrl}/Spotube-linux-x86_64.deb`,
    [FaUbuntu, FaDebian],
    "deb",
  ],
  "Ubuntu, Debian (arm64)": [
    `${releasesUrl}/Spotube-linux-aarch64.deb`,
    [FaUbuntu, FaDebian],
    "deb",
  ],
  "Fedora, Redhat, Opensuse": [
    `${releasesUrl}/Spotube-linux-x86_64.rpm`,
    [FaFedora, FaRedhat, FaOpensuse],
    "rpm",
  ],
  "Linux AppImage (x64)": [
    `${releasesUrl}/Spotube-linux-x86_64.AppImage`,
    [FaLinux],
    "AppImage",
  ],
  "Linux AppImage (arm64)": [
    `${releasesUrl}/Spotube-linux-aarch64.AppImage`,
    [FaLinux],
    "AppImage",
  ],
  iPhone: [`${releasesUrl}/Spotube-iOS.ipa`, [FaApple], "ipa"],
};

const nightlyReleaseUrl =
  "https://github.com/KRTirtho/Spotube/releases/download/nightly";

export const extendedNightlyDownloadLinks: Record<
  string,
  [string, IconType[], string]
> = {
  Android: [`${releasesUrl}/Spotube-android-all-arch.apk`, [FaAndroid], "apk"],
  Windows: [
    `${releasesUrl}/Spotube-windows-x86_64-setup.exe`,
    [FaWindows],
    "exe",
  ],
  macOS: [`${releasesUrl}/Spotube-macos-universal.dmg`, [FaApple], "dmg"],
  "Ubuntu, Debian (x64)": [
    `${releasesUrl}/Spotube-linux-x86_64.deb`,
    [FaUbuntu, FaDebian],
    "deb",
  ],
  "Ubuntu, Debian (arm64)": [
    `${releasesUrl}/Spotube-linux-aarch64.deb`,
    [FaUbuntu, FaDebian],
    "deb",
  ],
  "Fedora, Redhat, Opensuse": [
    `${releasesUrl}/Spotube-linux-x86_64.rpm`,
    [FaFedora, FaRedhat, FaOpensuse],
    "rpm",
  ],
  "Linux AppImage (x64)": [
    `${releasesUrl}/Spotube-linux-x86_64.AppImage`,
    [FaLinux],
    "AppImage",
  ],
  "Linux AppImage (arm64)": [
    `${releasesUrl}/Spotube-linux-aarch64.AppImage`,
    [FaLinux],
    "AppImage",
  ],
  iPhone: [`${releasesUrl}/Spotube-iOS.ipa`, [FaApple], "ipa"],
};

export const ADS_SLOTS = Object.freeze({
  rootPageDisplay: 5979549631,
  blogPageInFeed: 3386010031,
  downloadPageDisplay: 9928443050,
  packagePageArticle: 9119323068,
  // This is being used for rehype-auto-ads in svelte.config.js
  blogArticlePageArticle: 6788673194,
});
