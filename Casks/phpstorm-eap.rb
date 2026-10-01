cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.29"
  sha256 arm:   "bf9f64b11c81d479373b2beaea180ce0f491175371b7cabb9fb8681628dde274",
         intel: "58976b27ea54078b9ae4b08ad8e11fa54b091a007cda5b36c2a3eef857c97fd3"

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
