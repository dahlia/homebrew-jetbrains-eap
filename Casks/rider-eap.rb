cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.2-EAP5,262.7132.33"
  sha256 arm:   "66b0a54aa6b66c6ed45ca06369ebb5f21b6842dfb9673d6187c4aa344a565c0b",
         intel: "623c5a8e0f5b79ee41aea092d27dc3259c9af07fbbdfc9543a1d68b519f2ec52"

  url "https://download-cdn.jetbrains.com/rider/JetBrains.Rider-#{version.csv.first}-#{version.csv.second}.Checked#{arch}.dmg"
  name "JetBrains Rider EAP"
  desc ".NET IDE (EAP)"
  homepage "https://www.jetbrains.com/rider/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=eap"
    strategy :json do |json|
      json["RD"]&.map do |release|
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
  rename "Rider*.app", "Rider EAP.app"

  app "Rider EAP.app"
  binary "#{appdir}/Rider EAP.app/Contents/MacOS/rider", target: "rider-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "rider") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/Rider#{version.csv.first}",
    "~/Library/Caches/JetBrains/Rider#{version.csv.first}",
    "~/Library/Logs/JetBrains/Rider#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.rider-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.rider-EAP.savedState",
  ]
end
