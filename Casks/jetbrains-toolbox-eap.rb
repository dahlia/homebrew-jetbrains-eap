cask "jetbrains-toolbox-eap" do
  arch arm: "-arm64"

  version "3.7,3.7.0.86801"
  sha256 arm:   "8d5e2df29633800979943961bcda8f9aa5700de1d278485b81347d84c42f857a",
         intel: "cace5ace505bc94dcef637a9f3c65e314c451a72c857fc6717b340b7ae3ca7c8"

  url "https://download.jetbrains.com/toolbox/jetbrains-toolbox-#{version.csv.second}#{arch}.dmg"
  name "JetBrains Toolbox EAP"
  desc "JetBrains tools manager (EAP)"
  homepage "https://www.jetbrains.com/toolbox-app/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=eap"
    strategy :json do |json|
      json["TBA"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on :macos

  # The application path is often inconsistent between versions
  rename "JetBrains Toolbox*.app", "JetBrains Toolbox EAP.app"

  app "JetBrains Toolbox EAP.app"

  uninstall launchctl: "com.jetbrains.toolbox",
            signal:    ["TERM", "com.jetbrains.toolbox"]

  zap trash: [
        "~/Library/Application Support/JetBrains/Toolbox",
        "~/Library/Caches/JetBrains/Toolbox",
        "~/Library/Logs/JetBrains/Toolbox",
        "~/Library/Preferences/com.jetbrains.toolbox.renderer.plist",
        "~/Library/Saved Application State/com.jetbrains.toolbox.savedState",
      ],
      rmdir: [
        "~/Library/Application Support/JetBrains",
        "~/Library/Caches/JetBrains",
        "~/Library/Logs/JetBrains",
      ]
end
