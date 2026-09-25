cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5153.34"
  sha256 arm:   "acfc299fc1f6f73559ca8b6d942f9be1aec88ea64408db98406436c3ec59e1f7",
         intel: "c28f30efb435b1695376ac968c09ce2444fec47bf428234d3f95f7984b1ec2df"

  url "https://download.jetbrains.com/datagrip/datagrip-#{version.csv.second}#{arch}.dmg"
  name "DataGrip EAP"
  desc "Databases & SQL IDE (EAP)"
  homepage "https://www.jetbrains.com/datagrip/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=eap"
    strategy :json do |json|
      json["DG"]&.map do |release|
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
  rename "DataGrip*.app", "DataGrip EAP.app"

  app "DataGrip EAP.app"
  command_wrapper "datagrip-eap",
                  executable: "#{appdir}/DataGrip EAP.app/Contents/MacOS/datagrip"

  uninstall quit: "com.jetbrains.datagrip-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Caches/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Logs/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.datagrip-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.datagrip-EAP.savedState",
  ]
end
