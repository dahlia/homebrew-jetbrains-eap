cask "jetbrains-toolbox-eap" do
  arch arm: "-arm64"

  version "3.7,3.7.0.86431"
  sha256 arm:   "5b6f61add52a7ad17bacad3bdd9a1b3aa64be65e3e6b4b4258c5938804606654",
         intel: "4c777c485a4c0fe03da2068cde416b1eb51647546ff235638566923488fb8461"

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
