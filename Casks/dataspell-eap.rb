cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.21849.35"
  sha256 arm:   "104b494e18867a8815c50175ebcd71a03807e4776c68bdffea9af31788189f85",
         intel: "a0e98001151a99bfb9edf0d561642629868ed4e8d923817b416a41e445cc7bbe"

  url "https://download.jetbrains.com/python/dataspell-#{version.csv.second}#{arch}.dmg"
  name "DataSpell EAP"
  desc "IDE for Professional Data Scientists (EAP)"
  homepage "https://www.jetbrains.com/dataspell/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DS&latest=true&type=eap"
    strategy :json do |json|
      json["DS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "DataSpell*.app", "DataSpell EAP.app"

  app "DataSpell EAP.app"
  binary "#{appdir}/DataSpell EAP.app/Contents/MacOS/dataspell", target: "dataspell-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "dataspell") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/DataSpell#{version.csv.first}",
    "~/Library/Caches/JetBrains/DataSpell#{version.csv.first}",
    "~/Library/Logs/JetBrains/DataSpell#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.dataspell-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.dataspell-EAP.savedState",
  ]
end
