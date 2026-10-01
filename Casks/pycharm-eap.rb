cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.38"
  sha256 arm:   "a446043a6e5f073e75104683da5200ff7b0236b099b2138abd81016e8b12e157",
         intel: "aeb7ef00a565c15bc9137bc296ce6dcc284afb007201a8c6432e61d71506d655"

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
