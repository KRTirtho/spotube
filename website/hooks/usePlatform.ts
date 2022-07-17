import { useEffect, useState } from "react";

export enum Platform {
  linux = "Linux",
  windows = "Windows",
  mac = "Mac",
  android = "Android",
}

export function usePlatform(): Platform {
  const [platform, setPlatform] = useState(Platform.linux);

  useEffect(() => {
    const platform = (
      ((navigator as unknown as any).userAgentData?.platform as
        | string
        | undefined) ?? navigator.platform
    ).toLowerCase();

    if (platform.includes("windows")) setPlatform(Platform.windows);
    else if (platform.includes("mac")) setPlatform(Platform.mac);
    else if (platform.includes("android")) setPlatform(Platform.android);
  }, []);

  return platform;
}
