cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.3-EAP7,263.7031.38"
  sha256 arm:   "60a1775341580d3a73f4f8fb575f3bc234da924ef40dbbd8685ff6d085a35837",
         intel: "f8fd22024889cb418a058193b581fffc2689ff29a087532291f53368e486b687"

  url "https://download.jetbrains.com/rider/JetBrains.Rider-#{version.csv.first}-#{version.csv.second}.Checked#{arch}.dmg"
  name "JetBrains Rider EAP"
  desc ".NET IDE (EAP)"
  homepage "https://www.jetbrains.com/rider/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=eap"
    strategy :json do |json|
      json["RD"]&.map do |release|
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
  rename "Rider*.app", "Rider EAP.app"

  app "Rider EAP.app"
  command_wrapper "rider-eap",
                  executable: "#{appdir}/Rider EAP.app/Contents/MacOS/rider"

  uninstall quit: "com.jetbrains.rider-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Caches/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Logs/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Preferences/com.jetbrains.rider-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.rider-EAP.savedState",
  ]
end
