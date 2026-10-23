cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.44"
  sha256 arm:   "ca9e2e5e1a9c479458fef85232e4e4003136e8c78a1eb1c666b71510bf33c0df",
         intel: "5440698cdc6ef32a9d0ae4f0cd8ccc9c718469588813116e001074f1e43871e2"

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
