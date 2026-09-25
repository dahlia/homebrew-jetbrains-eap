cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5153.48"
  sha256 arm:   "7dc126e5265b6dfa4c2fce6f127005f397f0df6f29a94107c12e15a752b95de4",
         intel: "f5089eddeb61e76eddf0933fc68a431d15da4109005c08f1cad7f20b3b3e4a50"

  url "https://download.jetbrains.com/rustrover/RustRover-#{version.csv.second}#{arch}.dmg"
  name "RustRover EAP"
  desc "Rust IDE (EAP)"
  homepage "https://www.jetbrains.com/rust/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RR&latest=true&type=eap"
    strategy :json do |json|
      json["RR"]&.map do |release|
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
  rename "RustRover*.app", "RustRover EAP.app"

  app "RustRover EAP.app"
  binary "#{appdir}/RustRover EAP.app/Contents/MacOS/rustrover", target: "rustrover-eap"

  uninstall_postflight_steps do
    remove ["/usr/local/bin/rustrover", "{{HOMEBREW_PREFIX}}/bin/rustrover"],
           content_contains: "# see com.intellij.idea.SocketLock for the server side of this interface"
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Caches/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Logs/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.RustRover-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RustRover-EAP.savedState",
  ]
end
