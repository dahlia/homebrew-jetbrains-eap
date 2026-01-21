cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2025.3,253.27642.21"
  sha256 intel: "d112490bddc12a39d2b852a6d37b4c5ec31b70835b90176046ba9900681b1503",
         arm:   "a19db2ad8c9a8f5f791d101e1cbae2f4b6747e9b089698c0d712c79f76d780bd"

  url "https://download.jetbrains.com/python/dataspell-#{version.csv.second}#{arch}.dmg"
  name "DataSpell EAP"
  desc "IDE for Professional Data Scientists (EAP)"
  homepage "https://www.jetbrains.com/dataspell/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DS&release.type=eap"
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
