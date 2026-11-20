cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3.1,263.8311.42"
  sha256 arm:   "7d85a9e1c9f7c9c60a8598254d5cafdb97186c2ec5436a1ae9e4478c4306f572",
         intel: "b82d91dcf0e62187e0b7bd5c9338afc6eae6cb8a7a09205fb1128a6719566978"

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
