import { useEffect, useState } from "react";
import { detectOS } from "detect-browser";

export enum Platform {
  linux = "Linux",
  windows = "Windows",
  mac = "Mac",
  android = "Android",
}

export function usePlatform(): Platform {
  const [platform, setPlatform] = useState(Platform.linux);

  useEffect(() => {
    const detectedPlatform = detectOS(navigator.userAgent)?.toLowerCase();

    if (!detectedPlatform) return;

    if (detectedPlatform.includes("windows")) setPlatform(Platform.windows);
    else if (detectedPlatform.includes("mac")) setPlatform(Platform.mac);
    else if (detectedPlatform.includes("android"))
      setPlatform(Platform.android);
  }, []);

  return platform;
}
