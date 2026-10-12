cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.3-EAP6,263.6800.37"
  sha256 arm:   "f41d7c822471084d4100c50c7054bfaaf4bbdbd74cd56eb79daeef1ccec4659a",
         intel: "24e7dfc7c30439b9269e5e469a033a6c95c208b4562a651b3cf386c2a9c5bfa8"

  url "https://download.jetbrains.com/rider/JetBrains.Rider-#{version.csv.first}-#{version.csv.second}.Checked#{arch}.dmg"
  name "JetBrains Rider EAP"
  desc ".NET IDE (EAP)"
  homepage "https://www.jetbrains.com/rider/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=eap"
    strategy :json do |json|
      json["RD"]&.map do |release|
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
  rename "Rider*.app", "Rider EAP.app"

  app "Rider EAP.app"
  command_wrapper "rider-eap",
                  executable: "#{appdir}/Rider EAP.app/Contents/MacOS/rider"

  uninstall quit: "com.jetbrains.rider-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Caches/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Logs/JetBrains/Rider#{version.csv.first.split("-").first}",
    "~/Library/Preferences/com.jetbrains.rider-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.rider-EAP.savedState",
  ]
end
