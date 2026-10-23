cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.35"
  sha256 arm:   "82a6d3a80b0575889b540535c61261be6edb23021c816bb8021b85c0109025ac",
         intel: "a41b6950896f9a1a60c47ce88ff96bf665d75969f0b8501ec8643ffd6bbfc954"

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
