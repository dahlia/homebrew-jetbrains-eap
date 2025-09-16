cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2025.3,253.17525.99"
  sha256 arm:   "c73b9560fcf2a7af1638354293491cf5cf2dfd36477023d31f3ad25fc6b2a9c8",
         intel: "0f053581b267d15d39090bbd54e8cbf068e39ce97a58d3e1d6d4207dc6417d83"

  url "https://download.jetbrains.com/webide/PhpStorm-#{version.csv.second}#{arch}.dmg"
  name "JetBrains PhpStorm EAP"
  desc "PHP IDE by JetBrains (EAP)"
  homepage "https://www.jetbrains.com/phpstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["PS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "PhpStorm #{version.major_minor} EAP.app"
  binary "#{appdir}/PhpStorm #{version.major_minor} EAP.app/Contents/MacOS/phpstorm", target: "phpstorm-eap"

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
