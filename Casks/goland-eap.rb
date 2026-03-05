cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.22158.42"
  sha256 arm:   "4820d2b0290ae60b5add0a3c1557668ed2d38db9f5f73da5ef8f45865f401dce",
         intel: "9326761ecda55a259c4997288e002f96abb1cfe040aaeebcb79521a84d4aeec4"

  url "https://download.jetbrains.com/go/goland-#{version.csv.second}#{arch}.dmg"
  name "GoLand EAP"
  desc "Go (golang) IDE (EAP)"
  homepage "https://www.jetbrains.com/go/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=eap"
    strategy :json do |json|
      json["GO"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "GoLand*.app", "GoLand EAP.app"

  app "GoLand EAP.app"
  binary "#{appdir}/GoLand EAP.app/Contents/MacOS/goland", target: "goland-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "goland") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Caches/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Logs/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.goland-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.goland-EAP.SavedState",
  ]
end
