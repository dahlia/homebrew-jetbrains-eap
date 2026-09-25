cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5153.49"
  sha256 arm:   "9dd3322588ddddb5c4e6ecc0639f5c4f9a758a371c233690ad30240985c7ca24",
         intel: "6a82daae616cde5fcf0c72f0d6aed65e6e6530a15f10e2220ee6aed26e9a6e0c"

  url "https://download.jetbrains.com/python/pycharm-professional-#{version.csv.second}#{arch}.dmg"
  name "PyCharm EAP"
  name "PyCharm Professional EAP"
  desc "IDE for professional Python development (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PC&latest=true&type=eap"
    strategy :json do |json|
      json["PCP"]&.map do |release|
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
  rename "PyCharm*.app", "PyCharm EAP.app"

  app "PyCharm EAP.app"
  command_wrapper "pycharm-eap",
                  executable: "#{appdir}/PyCharm EAP.app/Contents/MacOS/pycharm"

  uninstall quit: "com.jetbrains.pycharm-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Caches/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Logs/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.pycharm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.pycharm-EAP.savedState",
  ]
end
