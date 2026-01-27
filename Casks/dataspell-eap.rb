cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.17801.86"
  sha256 intel: "7b449743ded4d71da5431f4a8c75fe80bb60ec036323095c99f34bd5b65c9b31",
         arm:   "d2520ba050c9aa0b6a94abff2f47fc1e1d1eab2210b5b742f7f87bf0241cd2fb"

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
