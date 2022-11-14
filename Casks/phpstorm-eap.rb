cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2022.3,223.7571.15"
  sha256 arm:   "c1f70d8c0731854c728b09fab6d7c5e002107ca49cd61f9bd8bb951861c6f783",
         intel: "9ffca4a204126b526cce839fda3d0dbfeb54e7bf1a27318dd4983ef9fe5d73c7"

  url "https://download.jetbrains.com/webide/PhpStorm-#{version.csv.second}#{arch}.dmg"
  name "JetBrains PhpStorm EAP"
  desc "PHP IDE by JetBrains (EAP)"
  homepage "https://www.jetbrains.com/pycharm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["PS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask/phpstorm"
  depends_on macos: ">= :high_sierra"

  app "PhpStorm #{version.major_minor} EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "pstorm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PhpStorm#{version.major_minor}",
    "~/Library/Caches/JetBrains/PhpStorm#{version.major_minor}",
    "~/Library/Logs/JetBrains/PhpStorm#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.PhpStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.PhpStorm-EAP.savedState",
  ]
end
