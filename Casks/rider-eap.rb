cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.1-EAP4,261.20869.54"
  sha256 intel: "7b6ad09095ec74f2093c436da62dc196f693771f7f38d7c7f785f08705a949ee",
         arm:   "c1f24f998e6d2a9d6436d38c76ca2ac96938a219025bae830c5de43c4b31cc8e"

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
