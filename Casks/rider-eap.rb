cask "rider-eap" do
  arch arm: "-aarch64"

  version "2025.3-EAP8,253.28086.30"
  sha256 intel: "8ae06f84ef6e4b8390793f8f09c1ff04a72ce966cba9fb39e80471c30b055910",
         arm:   "1ad7f5c6650af55c3f6c8220e3314c024bd66ab82e89c977699d6a740ba2e7a9"

  url "https://download-cdn.jetbrains.com/rider/JetBrains.Rider-#{version.csv.first}-#{version.csv.second}.Checked#{arch}.dmg"
  name "JetBrains Rider EAP"
  desc ".NET IDE (EAP)"
  homepage "https://www.jetbrains.com/rider/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RD&release.type=eap"
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
