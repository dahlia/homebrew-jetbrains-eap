cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6800.25"
  sha256 arm:   "f61e021ab75a1ebdf587edfc355d057e623b4b799fc24ade9a4fc49c1be2d658",
         intel: "6b661ca882a45a546ea38c2aa550f7d61fcd4db42c96cc939737e6d7c0d258aa"

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
