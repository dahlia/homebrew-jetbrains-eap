cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.38"
  sha256 arm:   "558f879841e901612e8886efe248be80571c070e4e88a8a88e8cff1aea407b6f",
         intel: "e400242500d6a5232043fa5ece9a863ffb26ea4e7a3bba893121924f6a78d73a"

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
