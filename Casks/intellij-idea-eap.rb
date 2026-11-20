cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2026.3.1,263.8311.30"
  sha256 arm:   "6740288e8c498170cc9c02584ea3ee5569b0d04d0e9a7fe8f59907c16595beda",
         intel: "a7191a1a348e8124a39fd7216266b85eef8f8e74d96b43e1dafb191dc9c32051"

  url "https://download.jetbrains.com/idea/ideaIU-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA EAP"
  desc "IntelliJ IDEA Early Access Program"
  homepage "https://www.jetbrains.com/idea/nextversion"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=II&latest=true&type=eap"
    strategy :json do |json|
      json["IIU"]&.map do |release|
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
  rename "IntelliJ IDEA*.app", "IntelliJ IDEA EAP.app"

  app "IntelliJ IDEA EAP.app"
  command_wrapper "idea-eap",
                  executable: "#{appdir}/IntelliJ IDEA EAP.app/Contents/MacOS/idea"

  uninstall quit: "com.jetbrains.intellij-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Caches/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Logs/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.intellij-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij-EAP.savedState",
  ]
end
