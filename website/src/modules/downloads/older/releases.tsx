import { formatDistanceToNow, formatRelative } from "date-fns";
import ReleaseBody from "~/modules/downloads/older/release-body";
import RootLayout from "~/layouts/RootLayout.astro";
import { Octokit, type RestEndpointMethodTypes } from "@octokit/rest";
import {
  FaAndroid,
  FaApple,
  FaGit,
  FaGooglePlay,
  FaLinux,
  FaWindows,
} from "react-icons/fa6";
import type { IconType } from "react-icons";
import { useEffect, useState } from "react";

function getIcon(assetUrl: string) {
  assetUrl = assetUrl.toLowerCase();
  if (assetUrl.includes("linux")) return FaLinux;
  if (assetUrl.includes("windows")) return FaWindows;
  if (assetUrl.includes("mac")) return FaApple;
  if (assetUrl.includes("android")) return FaAndroid;
  if (assetUrl.includes("playstore")) return FaGooglePlay;
  if (assetUrl.includes("ios")) return FaApple;

  return FaGit;
}

function formatName(assetName: string) {
  // format the assetName to be
  // {OS} ({package extension})

  const lowerCasedAssetName = assetName.toLowerCase();
  const extension = assetName.split(".").at(-1);

  if (lowerCasedAssetName.includes("linux")) {
    if (lowerCasedAssetName.includes("aarch64")) {
      return [`Linux`, extension, `ARM64`]
    }
    return [`Linux`, extension, `x64`]
  };
  if (lowerCasedAssetName.includes("windows")) return [`Windows`, extension];
  if (lowerCasedAssetName.includes("mac")) return [`macOS`, extension];
  if (
    lowerCasedAssetName.includes("android") ||
    lowerCasedAssetName.includes("playstore")
  )
    return [`Android`, extension];
  if (lowerCasedAssetName.includes("ios")) return [`iOS`, extension];

  return [assetName.replace(`.${extension}`, ""), extension];
}

type OctokitAsset =
  RestEndpointMethodTypes["repos"]["listReleases"]["response"]["data"][0]["assets"][0];

function groupByOS(downloads: OctokitAsset[]) {
  return downloads.reduce(
    (acc, val) => {
      const lowName = val.name.toLowerCase();

      if (lowName.includes("android") || lowName.includes("playstore"))
        acc["android"] = [...(acc.android ?? []), val];
      if (lowName.includes("linux"))
        acc["linux"] = [...(acc["linux"] ?? []), val];
      if (lowName.includes("windows"))
        acc["windows"] = [...(acc["windows"] ?? []), val];
      if (lowName.includes("ios")) acc["ios"] = [...(acc["ios"] ?? []), val];
      if (lowName.includes("mac")) acc["mac"] = [...(acc["mac"] ?? []), val];

      return acc;
    },
    {} as Record<
      "android" | "ios" | "mac" | "linux" | "windows",
      OctokitAsset[]
    >
  );
}

const icons: Record<string, [IconType, string]> = {
  android: [FaAndroid, "#3DDC84"],
  mac: [FaApple, ""],
  ios: [FaApple, ""],
  linux: [FaLinux, "#000000"],
  windows: [FaWindows, "#0078D7"],
};

export default function ReleasesSection() {
  const github = new Octokit();

  const [releases, setReleases] = useState<RestEndpointMethodTypes["repos"]["listReleases"]["response"]["data"]>([]);

  useEffect(() => {
    github.repos.listReleases({
      owner: "KRTirtho",
      repo: "spotube",

    }).then((res) => {
      setReleases(
        res.data.filter((release) => {
          // Ignore all releases that were published before March 18 2025
          return new Date(release.published_at ?? new Date()) >= new Date("2025-03-18T00:00:00Z");
        })
      );
    })

  }, [])

  return <>
    {
      releases.map((release) => {
        return (
          <div>
            <h4
              className="h4"
              title={formatRelative(
                release.published_at ?? new Date(),
                new Date()
              )}
            >
              {release.tag_name}
              <span className="text-sm font-normal">
                (
                {formatDistanceToNow(release.published_at ?? new Date(), {
                  addSuffix: true,
                })}
                )
              </span>
            </h4>

            <div className="flex flex-col gap-5">
              {Object.entries(groupByOS(release.assets)).map(
                ([osName, assets]) => {
                  const Icon = icons[osName][0];

                  return (
                    <div className="flex flex-col gap-4">
                      <h5 className="h5 capitalize">
                        <Icon className="inline" color={icons[osName][1]} />
                        {osName}
                      </h5>
                      <div className="flex flex-wrap gap-4">
                        {assets.map((asset) => {
                          const Icon = getIcon(asset.browser_download_url);
                          const formattedName = formatName(asset.name);

                          return (
                            <a href={asset.browser_download_url}>
                              <button className="btn preset-tonal-primary rounded p-0 flex flex-col">
                                <span className="bg-primary-500 rounded-t p-3 w-full">
                                  <Icon className="inline" />
                                </span>
                                <span className="p-4 space-x-1">
                                  <span>
                                    {formattedName[0]}
                                  </span>
                                  <span className="chip preset-tonal-error">
                                    {formattedName[1]}
                                  </span>
                                  {
                                    formattedName[2] ?
                                      <span className="chip preset-tonal-error">
                                        {formattedName[2]}
                                      </span> : <></>
                                  }
                                </span>
                              </button>
                            </a>
                          );
                        })}
                      </div>
                    </div>
                  );
                }
              )}
            </div>
            <ReleaseBody release={release} />
            <hr />
          </div>
        );
      })
    }
  </>
}