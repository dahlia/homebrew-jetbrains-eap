cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.36"
  sha256 arm:   "59e806c7a40afed7a0f295f644437ad806db6652f328753bb77b36aff5dac123",
         intel: "e1b265e9341bbae91c32e576af83d51c89d6a4edd12e82666b69235a80f6c05a"

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
