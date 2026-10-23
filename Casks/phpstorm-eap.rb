cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.51"
  sha256 arm:   "b6decf49c37f33e8bca25d220bbf96b1f726459b5a56a4eb3ac89dc6df13f8df",
         intel: "f986da908304e74f056d062ff159e4f2f6fd0fc71b0e90a2d97bfe5beb406be7"

  url "https://download.jetbrains.com/webide/PhpStorm-#{version.csv.second}#{arch}.dmg"
  name "JetBrains PhpStorm EAP"
  desc "PHP IDE by JetBrains (EAP)"
  homepage "https://www.jetbrains.com/phpstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=eap"
    strategy :json do |json|
      json["PS"]&.map do |release|
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
  rename "PhpStorm*.app", "PhpStorm EAP.app"

  app "PhpStorm EAP.app"
  command_wrapper "phpstorm-eap",
                  executable: "#{appdir}/PhpStorm EAP.app/Contents/MacOS/phpstorm"

  uninstall quit: "com.jetbrains.PhpStorm-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Caches/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Logs/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.PhpStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.PhpStorm-EAP.savedState",
  ]
end
