cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.36"
  sha256 arm:   "366d5f3f78879133bc4cdd83a4250bf543db037089018bcecffb06138586a04e",
         intel: "b3f8f15201a0707f681008f6345d4ba9022af65c2e12079828df4c3de5442d2e"

  url "https://download.jetbrains.com/go/goland-#{version.csv.second}#{arch}.dmg"
  name "GoLand EAP"
  desc "Go (golang) IDE (EAP)"
  homepage "https://www.jetbrains.com/go/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=eap"
    strategy :json do |json|
      json["GO"]&.map do |release|
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
  rename "GoLand*.app", "GoLand EAP.app"

  app "GoLand EAP.app"
  command_wrapper "goland-eap",
                  executable: "#{appdir}/GoLand EAP.app/Contents/MacOS/goland"

  uninstall quit: "com.jetbrains.goland-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Caches/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Logs/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.goland-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.goland-EAP.SavedState",
  ]
end
