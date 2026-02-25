cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.21525.30"
  sha256 arm:   "852bce41ed9748a3bd277d90f4ba913076cd81069312f7f8b1532750e5cdf290",
         intel: "84496abe90cba2cbacac9e419d5fcf50efafd6d9ec623d3f02b013468f46feb1"

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.csv.second}#{arch}.dmg"
  name "WebStorm EAP"
  desc "JavaScript IDE (EAP)"
  homepage "https://www.jetbrains.com/webstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap"
    strategy :json do |json|
      json["WS"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "WebStorm*.app", "WebStorm EAP.app"

  app "WebStorm EAP.app"
  binary "#{appdir}/WebStorm EAP.app/Contents/MacOS/webstorm", target: "webstorm-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "wstorm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Caches/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Logs/JetBrains/WebStorm#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState",
  ]
end
