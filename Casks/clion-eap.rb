cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.39"
  sha256 arm:   "9a80c29cdc42833bd7ba040e9f994b1756286f1b97cbf0c689fb8889d5fdbb4e",
         intel: "63689b2d997fd5333d520b0ea3f84f25fc354cc1d3fd578b91b34d6285c8d959"

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
