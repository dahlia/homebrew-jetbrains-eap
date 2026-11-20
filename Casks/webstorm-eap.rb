cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3.1,263.8311.23"
  sha256 arm:   "438d9c8ce8911532ab391f794c57a75548d1ca1f291e5353395d822c03d63d44",
         intel: "fa82e3df27e440995c4d4bec694ac1bcf25f166f3c575f4f0c95c01e98eb1e5c"

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.csv.second}#{arch}.dmg"
  name "WebStorm EAP"
  desc "JavaScript IDE (EAP)"
  homepage "https://www.jetbrains.com/webstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap"
    strategy :json do |json|
      json["WS"]&.map do |release|
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
  rename "WebStorm*.app", "WebStorm EAP.app"

  app "WebStorm EAP.app"
  command_wrapper "webstorm-eap",
                  executable: "#{appdir}/WebStorm EAP.app/Contents/MacOS/webstorm"

  uninstall quit: "com.jetbrains.WebStorm-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Caches/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Logs/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState",
  ]
end
