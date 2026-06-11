cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.7581.3"
  sha256 arm:   "d71de19f9485920a8665acc8fde99f037d22b538d029f791896330cda79de53c",
         intel: "150cc52df6e2e8f404263f27416baf5283bd65fb033c124853f1420eb439a529"

  url "https://download.jetbrains.com/datagrip/datagrip-#{version.csv.second}#{arch}.dmg"
  name "DataGrip EAP"
  desc "Databases & SQL IDE (EAP)"
  homepage "https://www.jetbrains.com/datagrip/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=eap"
    strategy :json do |json|
      json["DG"]&.map do |release|
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
  rename "DataGrip*.app", "DataGrip EAP.app"

  app "DataGrip EAP.app"
  binary "#{appdir}/DataGrip EAP.app/Contents/MacOS/datagrip", target: "datagrip-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "datagrip") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Caches/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Logs/JetBrains/DataGrip#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.datagrip-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.datagrip-EAP.savedState",
  ]
end
