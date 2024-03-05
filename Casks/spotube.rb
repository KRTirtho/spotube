cask "spotube" do
  version "3.4.1"
  sha256 "5686cb0b1b261399062250c36b7bf9c481e4c36c76615d787e01c77036fe6cba"

  url "https://github.com/KRTirtho/spotube/releases/download/v#{version}/Spotube-macos-universal.dmg",
      verified: "github.com/KRTirtho/spotube/"
  name "Spotube"
  desc "🎧 Open source Spotify client that doesn't require Premium nor uses Electron! Available for both desktop & mobile!"
  homepage "https://spotube.krtirtho.dev/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "spotube.app"

  zap trash: [
    "~/Library/Application Scripts/oss.krtirtho.spotube",
    "~/Library/Containers/oss.krtirtho.spotube",
  ]
end