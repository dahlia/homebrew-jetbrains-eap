cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.47"
  sha256 arm:   "68da6c97c0ada3cb155960c0fc93404e61841298ce86b411ec5886e74cfa9593",
         intel: "5d52fa6b7ba9ffec974cb898ed5274e05fbe94d4f32a3fbcfea4f49c32e0ff5e"

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
