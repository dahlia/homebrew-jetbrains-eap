cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.20869.40"
  sha256 arm:   "8f0bbc7ed94239e9867fcb28497b98ce39ad965b3e9e6ce540ab3061d15e797b",
         intel: "3606590d7b3129b8495df349e6eb3777d56e34deabfc5f5fc2725c65896249a2"

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
