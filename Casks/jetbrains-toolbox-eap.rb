cask "jetbrains-toolbox-eap" do
  arch arm: "-arm64"

  version "3.10,3.10.0.89820"
  sha256 arm:   "3fca13f0ae5da02406daa14d960f49f4df3fa58f8af2480226bc9bce11171e7b",
         intel: "d3541f1ed0b4f9c664ef84e8f041c187cad41bea2c4734fb27e6a810f428507f"

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
  conflicts_with cask: "jetbrains-toolbox"
  depends_on :macos

  # The application path is often inconsistent between versions
  rename "JetBrains Toolbox*.app", "JetBrains Toolbox EAP.app"

  app "JetBrains Toolbox EAP.app"

  uninstall launchctl: "com.jetbrains.toolbox",
            quit:      "com.jetbrains.toolbox",
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
