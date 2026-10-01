cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.35"
  sha256 arm:   "2dbebf46f451dabcf81f595c94de01e6eb4a8392d61a0392aab10d5eb3694391",
         intel: "c5ad20362f50d798126a32093d30596a531dd3c234e1d58f8a2f31197ea2e033"

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
