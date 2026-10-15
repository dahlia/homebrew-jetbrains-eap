cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.26"
  sha256 arm:   "cd77efc16ec8166cff0533eca447233e84ace42cf4a9f82f20c8b3620690e23d",
         intel: "071e5249a09ac86721c0a10b36ab3f0069f71e0e44b2d491d058c96d69528722"

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
