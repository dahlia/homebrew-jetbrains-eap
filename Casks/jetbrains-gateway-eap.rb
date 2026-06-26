cask "jetbrains-gateway-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.8377.44"
  sha256 arm:   "89adb9c1bf3391b0a3ff03212ae64b4f37a0e0092213556a5d12304f9db839d5",
         intel: "5bf963d9cd64672bf01fe80616cb7064d6ff2e8dadc7648d80783f310950909e"

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
  binary "#{appdir}/JetBrains Gateway EAP.app/Contents/MacOS/gateway", target: "gateway-eap"

  zap trash: [
    "~/Library/Application Support/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Caches/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Logs/JetBrains/JetBrainsGateway#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.gateway.plist",
    "~/Library/Saved Application State/com.jetbrains.gateway.savedState",
  ]
end
