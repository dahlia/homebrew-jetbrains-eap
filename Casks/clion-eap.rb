cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.19"
  sha256 arm:   "da8ac48722b286182634a6e2c72f9112ca7898c347d6715a42944bca4dd5745c",
         intel: "9026ccb004fc8ba74c199c74e59d365b43b1d9a8f3126ce0843432f3c8d1f5ff"

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
