cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.3-EAP9,263.7307.100"
  sha256 arm:   "041c214c767d1cef5aa4b9f34523fb2338532b58cef9a547fc170b07c4c14e7f",
         intel: "63efc1175d767ba5526856734b7f96cd1f8e74ef00fe6e398e9f7fbec915d699"

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
