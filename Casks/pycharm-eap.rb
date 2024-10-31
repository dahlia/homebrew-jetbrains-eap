cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2024.3,243.21565.33"
  sha256 intel: "ef4db20287bfbaae57d5937a7184d16c7886b6d8e9b5962d4fe1e34a2ca775e2",
         arm:   "c97f2efa4af08142fd58333f2ee46d2a949b1875fc9902fa65502e452ec4f654"

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
