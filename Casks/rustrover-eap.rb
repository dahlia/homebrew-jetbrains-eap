cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.25"
  sha256 arm:   "2233ba22dca66fe02d2498cd6dd7a5634c22a6b87fa01f89429b0699f56bdb99",
         intel: "7ffd6ed28126be5c29f2ed3b09f004388be2ca0ea3c30b83e2515018315fe46c"

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
