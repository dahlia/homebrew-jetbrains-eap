cask "pycharm-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.8117.23"
  sha256 arm:   "076eeb975586a5f49265784327bdc0e774ab13f23db89f3a83f6fddd0ddd5638",
         intel: "0832d3dabc404f712c6246821848660d451de6ac2b1e45619e397e0a85bbae11"

  url "https://download.jetbrains.com/python/pycharm-professional-#{version.csv.second}#{arch}.dmg"
  name "PyCharm EAP"
  name "PyCharm Professional EAP"
  desc "IDE for professional Python development (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PC&latest=true&type=eap"
    strategy :json do |json|
      json["PCP"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on :macos

  # The application path is often inconsistent between versions
  rename "PyCharm*.app", "PyCharm EAP.app"

  app "PyCharm EAP.app"
  binary "#{appdir}/PyCharm EAP.app/Contents/MacOS/pycharm", target: "pycharm-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "charm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Caches/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Logs/JetBrains/PyCharm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.pycharm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.pycharm-EAP.savedState",
  ]
end
