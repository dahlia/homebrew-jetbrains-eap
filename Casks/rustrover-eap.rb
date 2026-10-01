cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.37"
  sha256 arm:   "73838e3380f7661a8cdc1f37b662d9c5036dd158b0003e3b292f259e84bd3ef3",
         intel: "9e2cc6a3bb38d0eee3bc9011cb196fa8c6a0a9a43c94be81a977f5bf82545073"

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
