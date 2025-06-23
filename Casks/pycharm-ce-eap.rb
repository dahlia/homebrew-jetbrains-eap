cask "pycharm-ce-eap" do
  arch arm: "-aarch64"

  version "2025.2,252.23309.36"
  sha256 intel: "6fcaf30fadc17cb62f3aea2e6c4f17d7257dc5b1eebe7fe8a865865e6874a355",
         arm:   "431f787f073f068e0666b65ac89fa2c8e9536163d11d235361fae50fa3ec2e56"

  url "https://download.jetbrains.com/python/pycharm-community-#{version.csv.second}#{arch}.dmg"
  name "Jetbrains PyCharm Community Edition EAP"
  name "PyCharm CE EAP"
  desc "IDE for Python programming - Community Edition (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["PCC"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PyCharm CE #{version.major_minor} EAP.app"
  binary "#{appdir}/PyCharm CE #{version.major_minor} EAP.app/Contents/MacOS/pycharm", target: "pycharm-ce-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "charm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Caches/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Logs/JetBrains/PyCharmCE#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.pycharm.ce-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.pycharm.ce-EAP.savedState",
  ]
end
