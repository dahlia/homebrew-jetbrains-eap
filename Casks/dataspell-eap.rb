cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2024.2,242.20224.180"
  sha256 intel: "132705f2d9561a8c2faa6cfc7815da466d8ff458031f15145acb87b2684c72e2",
         arm:   "df91585fd14d72b6994721356601d27a59ddec0170b51c41a4fba991f6505712"

  url "https://download.jetbrains.com/python/dataspell-#{version.csv.second}#{arch}.dmg"
  name "DataSpell EAP"
  desc "IDE for Professional Data Scientists (EAP)"
  homepage "https://www.jetbrains.com/dataspell/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DS&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["DS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DataSpell #{version.major_minor} EAP.app"
  binary "#{appdir}/DataSpell #{version.major_minor} EAP.app/Contents/MacOS/dataspell", target: "dataspell-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "dataspell") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/DataSpell#{version.major_minor}",
    "~/Library/Caches/JetBrains/DataSpell#{version.major_minor}",
    "~/Library/Logs/JetBrains/DataSpell#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.dataspell-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.dataspell-EAP.savedState",
  ]
end
