cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.7132.36"
  sha256 arm:   "750768d177b7714a7fffa85963b2a6798d1a87c657918df671e5783f707c10b9",
         intel: "3a17855a2dfe588d8fafb7c120a6ef3eff5bbcd25bc77ba6e39c4b6f2ff9f4ed"

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
  depends_on :macos

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
