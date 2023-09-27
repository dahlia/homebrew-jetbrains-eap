cask "pycharm-ce-eap" do
  arch arm: "-aarch64"

  version "2023.3,233.6745.319"
  sha256 intel: "5d56fc09cf6695b505aa0dac3e3b8880d5ac4d6ca68476c651536a4984c8625c",
         arm:   "7303eb6f72c2ee2e6c0cc56c2e898fb5235f811ba8593622c81b104a665b33b5"

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
