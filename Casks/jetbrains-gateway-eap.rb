cask "jetbrains-gateway-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.6653.20"
  sha256 arm:   "203e35c0bad14ce481fddb741af749b6a994c09748f2b6b5497197a39c37f063",
         intel: "98fcc83ec404d50e7cd75e6067b0febfda937981e805132a01405437217b291a"

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
  depends_on :macos

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
