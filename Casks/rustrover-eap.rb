cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.45"
  sha256 arm:   "131e0b68df5336562f89e16787252b1e2d2f4707923681b47c388afc97259934",
         intel: "2066ceac385d8637d88fb6f992b29c43b73015427116b4c9e29c381a85a73bbd"

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
  command_wrapper "rustrover-eap",
                  executable: "#{appdir}/RustRover EAP.app/Contents/MacOS/rustrover"

  uninstall quit: "com.jetbrains.RustRover-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Caches/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Logs/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.RustRover-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RustRover-EAP.savedState",
  ]
end
