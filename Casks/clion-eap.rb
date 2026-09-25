cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.36"
  sha256 arm:   "26b52a1b5b598de6c0f8dae6709f422735d920e93315796fe2c3f0993dc50d8f",
         intel: "fef438a1a4c08952889fa086da22e1b483b0b826c8b2763dfb7bb86f8d33626b"

  url "https://download.jetbrains.com/cpp/CLion-#{version.csv.second}#{arch}.dmg"
  name "CLion EAP"
  desc "C and C++ IDE (EAP)"
  homepage "https://www.jetbrains.com/clion/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=eap"
    strategy :json do |json|
      json["CL"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: :monterey

  # The application path is often inconsistent between versions
  rename "CLion*.app", "CLion EAP.app"

  app "CLion EAP.app"
  command_wrapper "clion-eap",
                  executable: "#{appdir}/CLion EAP.app/Contents/MacOS/clion"

  uninstall quit: "com.jetbrains.CLion-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/CLion#{version.csv.first}",
    "~/Library/Caches/JetBrains/CLion#{version.csv.first}",
    "~/Library/Logs/JetBrains/CLion#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.CLion-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.CLion-EAP.savedState",
  ]
end
