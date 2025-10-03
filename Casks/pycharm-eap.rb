cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2025.3,253.24325.40"
  sha256 intel: "c4d177c5ded78fde902a49cd3a1de04e1a3fdaedc386b4efaa834a5e3b1457b6",
         arm:   "c3df32906ccda92fd8f7b40606b2732931eab43e94253a1b89451807d02683a1"

  url "https://download.jetbrains.com/python/pycharm-professional-#{version.csv.second}#{arch}.dmg"
  name "PyCharm EAP"
  name "PyCharm Professional EAP"
  desc "IDE for professional Python development (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["PCP"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PyCharm #{version.major_minor} EAP.app"
  binary "#{appdir}/PyCharm #{version.major_minor} EAP.app/Contents/MacOS/pycharm", target: "pycharm-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "charm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PyCharm#{version.major_minor}",
    "~/Library/Caches/JetBrains/PyCharm#{version.major_minor}",
    "~/Library/Logs/JetBrains/PyCharm#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.pycharm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.pycharm-EAP.savedState",
  ]
end
