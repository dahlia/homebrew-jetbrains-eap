cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2025.1,251.20015.34"
  sha256 arm:   "6cb2e6f2efcd138ce7c3c7bab55b435f4cbb4f2daa02239b7b25c486547431ff",
         intel: "413e5e6e526ffebe3f2cd5dd7cc2d65c1e4d07ea2205d55b59560b10bd86f1df"

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
