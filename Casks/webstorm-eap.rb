cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.49"
  sha256 arm:   "669df50ded77f5b5addddcc6ff03a659c6b7c32c2892b59e99d47aedff9c796d",
         intel: "cd0432b55ade342ae736053de909ecf23b1783b3d666d5ca675c5d34d4201981"

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
