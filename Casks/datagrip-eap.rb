cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.43"
  sha256 arm:   "1e58d31c58d185ee8314ccfc6926fa0e80ed996969ed2996f622a7d425326712",
         intel: "06477a4bac4c292ad918a75bfcf57e6aec4d177d9b917740bd0774e73f0286de"

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
