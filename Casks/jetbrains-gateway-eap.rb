cask "jetbrains-gateway-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.46"
  sha256 arm:   "155fc12dca9374616add6a2127401437462ac998d9bda9c2d9e0873a1fcb26f7",
         intel: "e9d59912e7b488b1754cb70805992f476da57e89fc0bd04f2014bc5d03df43ac"

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
