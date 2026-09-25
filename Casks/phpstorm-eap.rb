cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.46"
  sha256 arm:   "71036bbfdaa04c2e71a5f27551934d8a0bcfbb738fe932631d20c865028115d0",
         intel: "56fd7a500f7f1389d5d488be888f76bc040ee8f7c49811564fd0879779d6e444"

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
