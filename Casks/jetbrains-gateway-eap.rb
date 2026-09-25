cask "jetbrains-gateway-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.43"
  sha256 arm:   "b24fbd09f6090e205fea366c8dad27afd50c9de2fadbe647aec06b042250db25",
         intel: "68c2355f97e9868e8cdcb418ea573635b3a564661f1afd87c5c1d2940d0e1338"

  url "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-#{version.csv.second}#{arch}.dmg"
  name "JetBrains Gateway EAP"
  desc "Remote development gateway by JetBrains (EAP)"
  homepage "https://www.jetbrains.com/remote-development/gateway/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GW&latest=true&type=eap"
    strategy :json do |json|
      json["GW"]&.map do |release|
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
  rename "JetBrains Gateway*.app", "JetBrains Gateway EAP.app"

  app "JetBrains Gateway EAP.app"
  command_wrapper "gateway-eap",
                  executable: "#{appdir}/JetBrains Gateway EAP.app/Contents/MacOS/gateway"

  uninstall quit: "com.jetbrains.gateway-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Caches/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Logs/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.gateway-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.gateway-EAP.savedState",
  ]
end
