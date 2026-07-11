cask "jetbrains-toolbox-eap" do
  arch arm: "-arm64"

  version "3.6.2,3.6.2.85810"
  sha256 arm:   "87b9830a8cf65cc3a08c04f720c8525ca222fd488b1dde2bfbedc356244c25c0",
         intel: "368b3c9ec1f67d6bdc9e8f446ffaae9451621cfc89179ab0b8462b8e8bd17a4c"

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
