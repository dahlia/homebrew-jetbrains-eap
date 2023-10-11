cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2023.3,233.9102.195"
  sha256 intel: "edb4816ce001e30d3ec47c18f7575467f867deb6d4b6d16aff41135b26ab0f02",
         arm:   "cd3b37db68038e2a0bf8ec94e2cbda94332749e8763997efb248c56d9341571b"

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
