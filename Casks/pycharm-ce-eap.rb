cask "pycharm-ce-eap" do
  arch arm: "-aarch64"

  version "2024.2,242.18071.12"
  sha256 intel: "b689440423e0889e11d7b9480fcd6e48b12302ade02c27f31f36907b7b9f2702",
         arm:   "4d640e9e5cff9b5ab40e68b4c04c865e57769953d09e0aec7e9534582d400ef1"

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
