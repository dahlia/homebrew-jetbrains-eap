cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.113"
  sha256 arm:   "92f2eff3550eb507a1471fe6fb0c6e965efcc573301d8740312bcde9b2a5ed42",
         intel: "16efb4b0097286090fe2e05cc80f2ff95add5086e953263acfd41ababaa38bb9"

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
