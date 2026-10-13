cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6800.43"
  sha256 arm:   "c00fe70d71124f0e5113950b31fd430d1901879d92157d9ec1056f58fd795a36",
         intel: "ef2fd532c4cd577d235b45febb3b5290a838e2dae9561d5c550fb97ee368d479"

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
