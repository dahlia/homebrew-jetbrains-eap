cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.45"
  sha256 arm:   "09ad4553a26fedb1dd399bc13016334b6243c1de92237280adc6297231ccedf2",
         intel: "e66bdd2afac98523a19bc1fbe65e5d34d05e229d47c784dee0c8b4fa784fc922"

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
