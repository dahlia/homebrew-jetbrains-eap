cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.65"
  sha256 arm:   "c76534445359d29d09e8d98a5175ac3ab743312762f9a8ab5beffcecccd373d3",
         intel: "c7e63053f0b0948683fa8299804385c4672468ce772e006a988dc33b9340fefa"

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
