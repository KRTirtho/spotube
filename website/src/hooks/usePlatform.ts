export enum Platform {
  linux = "Linux",
  windows = "Windows",
  mac = "Mac",
  android = "Android",
}

export function usePlatform(): Platform {
  const platform = (
    ((navigator as unknown as any).userAgentData?.platform as
      | string
      | undefined) ?? navigator.platform
  ).toLowerCase();

  if (platform.includes("windows")) return Platform.windows;
  else if (platform.includes("mac")) return Platform.mac;
  else if (platform.includes("android")) return Platform.android;
  else return Platform.linux;
}
