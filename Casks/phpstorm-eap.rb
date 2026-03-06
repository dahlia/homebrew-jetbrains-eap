cask "phpstorm-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.22158.45"
  sha256 arm:   "3ac085000c903743774e0c0f03caab8980db81dbeed509f7a28232f0e6ccc253",
         intel: "0fe756d202b43d6a8e70c6acef89d4830cac06810b86a81f59683426303328ab"

  url "https://download.jetbrains.com/webide/PhpStorm-#{version.csv.second}#{arch}.dmg"
  name "JetBrains PhpStorm EAP"
  desc "PHP IDE by JetBrains (EAP)"
  homepage "https://www.jetbrains.com/phpstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=PS&latest=true&type=eap"
    strategy :json do |json|
      json["PS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "PhpStorm*.app", "PhpStorm EAP.app"

  app "PhpStorm EAP.app"
  binary "#{appdir}/PhpStorm EAP.app/Contents/MacOS/phpstorm", target: "phpstorm-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "pstorm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Caches/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Logs/JetBrains/PhpStorm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.PhpStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.PhpStorm-EAP.savedState",
  ]
end
