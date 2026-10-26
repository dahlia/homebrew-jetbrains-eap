cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.3-EAP8,263.7307.48"
  sha256 arm:   "fad1da6f37b753c21a5d23da8545d5be58819a65910e12f42fe029fecaf902e3",
         intel: "587664d66ec89760e28b78cee000e3fe3c612247b3917ca46f4d700b9155ee07"

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
