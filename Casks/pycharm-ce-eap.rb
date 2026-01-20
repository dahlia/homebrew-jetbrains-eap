cask "pycharm-ce-eap" do
  arch arm: "-aarch64"

  version "2025.2,252.23892.194"
  sha256 intel: "f632cd773a122787fd29faa0552d7bbcadc2d373b6cce37b791a068d77231830",
         arm:   "584a806be4130f7f63a221c8068bcd6a170d6d2f6cb7e92e6e74d4b8c13643b7"

  url "https://download.jetbrains.com/python/pycharm-community-#{version.csv.second}#{arch}.dmg"
  name "Jetbrains PyCharm Community Edition EAP"
  name "PyCharm CE EAP"
  desc "IDE for Python programming - Community Edition (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  # https://blog.jetbrains.com/pycharm/2025/12/pycharm-2025-3-unified-ide-jupyter-notebooks-in-remote-development-uv-as-default-and-more/
  deprecate! date: "2025-12-08", because: :discontinued, replacement_cask: "pycharm-eap"

  auto_updates true

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
