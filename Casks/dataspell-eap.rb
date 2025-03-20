cask "dataspell-eap" do
  arch arm: "-aarch64"

  version "2025.1,251.23774.146"
  sha256 intel: "d205723d27dec66959c379aa4785412fe1f95a7b38b7379310aa0814cf8e1c6d",
         arm:   "f70f9f3dd4b2c7806df748a847ca73599df0058ec1f8b64ecc7b66e55dae3ffd"

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
