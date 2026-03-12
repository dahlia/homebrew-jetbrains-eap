cask "rider-eap" do
  arch arm: "-aarch64"

  version "2026.1-EAP8,261.22158.95"
  sha256 arm:   "b486890d3bbc83ddc0d203cc755c29da53ffd02cefcdef7b0ec2c65ffe4bd257",
         intel: "fbff86d7bea777658ec99752ccb6650865c3a3a027940862e2a8bb59916a42b0"

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
