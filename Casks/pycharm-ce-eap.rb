cask "pycharm-ce-eap" do
  arch arm: "-aarch64"

  version "2023.2,232.8296.19"
  sha256 intel: "bbdc66d71ea2c4448ca8ef6322805bbc4e8d0eb6961db85529ac0deb79d119b0",
         arm:   "cfe3e2dfb559eb16d01df0d9b9dc4706594c5f15d99edcce223cf1d621697df8"

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
