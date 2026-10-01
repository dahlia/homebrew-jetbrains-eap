cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.3-EAP5,263.6259.33"
  sha256 arm:   "6f7ef7ed233c5a27def33b8de062641435d546a11b1c61f015c6ebedf20798a5",
         intel: "ff189a0af12722c4227d881e8ef6f76c56a3098996df69998b79dc53aa886620"

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
