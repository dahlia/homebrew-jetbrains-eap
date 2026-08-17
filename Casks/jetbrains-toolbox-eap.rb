cask "jetbrains-toolbox-eap" do
  arch arm: "-arm64"

  version "3.7,3.7.0.87063"
  sha256 arm:   "b588d4416ac285a4adf8ae967a0e4cf4b223d977f0981a53feea0706fbac9c27",
         intel: "5608ddb4ff9c35654b6521ddd64717727d9a0e7b1253282957c3a36c6f2173b6"

  url "https://download.jetbrains.com/toolbox/jetbrains-toolbox-#{version.csv.second}#{arch}.dmg"
  name "JetBrains Toolbox EAP"
  desc "JetBrains tools manager (EAP)"
  homepage "https://www.jetbrains.com/toolbox-app/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=eap"
    strategy :json do |json|
      json["TBA"]&.map do |release|
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
  rename "JetBrains Toolbox*.app", "JetBrains Toolbox EAP.app"

  app "JetBrains Toolbox EAP.app"

  uninstall launchctl: "com.jetbrains.toolbox",
            signal:    ["TERM", "com.jetbrains.toolbox"]

  zap trash: [
        "~/Library/Application Support/JetBrains/Toolbox",
        "~/Library/Caches/JetBrains/Toolbox",
        "~/Library/Logs/JetBrains/Toolbox",
        "~/Library/Preferences/com.jetbrains.toolbox.renderer.plist",
        "~/Library/Saved Application State/com.jetbrains.toolbox.savedState",
      ],
      rmdir: [
        "~/Library/Application Support/JetBrains",
        "~/Library/Caches/JetBrains",
        "~/Library/Logs/JetBrains",
      ]
end
