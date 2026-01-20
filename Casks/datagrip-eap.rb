cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2025.3,253.28294.90"
  sha256 intel: "ea4675bf8b82d1838a60349a7f29922e2ca1aaea71ccc81c5c7d45816a5821b0",
         arm:   "3df9d0a1a108931766a70a3248c87f4bc0169467e6c4ccc27f355c6b48431643"

  url "https://download.jetbrains.com/datagrip/datagrip-#{version.csv.second}#{arch}.dmg"
  name "DataGrip EAP"
  desc "Databases & SQL IDE (EAP)"
  homepage "https://www.jetbrains.com/datagrip/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DG&release.type=eap"
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
