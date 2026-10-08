cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6800.10"
  sha256 arm:   "44f14af511b32a1896104066395a09bcb3ff08692048990c254263cc83c1ffd1",
         intel: "c096cfb8bf47a6abeece5e8f3d211d29414bc61f9742709313f8d8cfc58eb343"

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
