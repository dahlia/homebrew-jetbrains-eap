cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.42"
  sha256 arm:   "72b719ab6f219205dbb34afc9c0f4357c8371d2d59185ff8380f01a724d19e49",
         intel: "2f6ea3628ae995ed67e75f76ca13dc6400345dfd3659c23443ea5f598e49fd6e"

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
