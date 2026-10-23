cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.50"
  sha256 arm:   "02e834abb0dae74e87ad59004a12d1d3096214e4c9b3dd6423d74144c185b149",
         intel: "8142b9aa34be40331f6636912e8f294429458b2c22ee8c2990c39efde7a89d43"

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
