cask "jetbrains-gateway-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.4852.55"
  sha256 arm:   "51999434d4f43e4c97b4aed0ed02ca81019f23848ff516ec66540e5a9cf93896",
         intel: "a8a15da6a3e63cf765e33a2994955d8372efcbdab141dba7762c6972b7feedb2"

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

  # The application path is often inconsistent between versions
  rename "JetBrains Gateway*.app", "JetBrains Gateway EAP.app"

  app "JetBrains Gateway EAP.app"
  binary "#{appdir}/JetBrains Gateway EAP.app/Contents/MacOS/gateway", target: "gateway-eap"

  zap trash: [
    "~/Library/Application Support/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Caches/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Logs/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.gateway.plist",
    "~/Library/Saved Application State/com.jetbrains.gateway.savedState",
  ]
end
