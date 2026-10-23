cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.43"
  sha256 arm:   "8302cc628840b212ae1775065ff9e6db0070aa69defa46984c05267ab7fcd2f3",
         intel: "e0965260eb277f6565075e364bfc1e751a1c17a1ddf366f3dc019c6580b91ed6"

  url "https://download.jetbrains.com/go/goland-#{version.csv.second}#{arch}.dmg"
  name "GoLand EAP"
  desc "Go (golang) IDE (EAP)"
  homepage "https://www.jetbrains.com/go/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=eap"
    strategy :json do |json|
      json["GO"]&.map do |release|
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
  rename "GoLand*.app", "GoLand EAP.app"

  app "GoLand EAP.app"
  command_wrapper "goland-eap",
                  executable: "#{appdir}/GoLand EAP.app/Contents/MacOS/goland"

  uninstall quit: "com.jetbrains.goland-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Caches/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Logs/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.goland-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.goland-EAP.SavedState",
  ]
end
