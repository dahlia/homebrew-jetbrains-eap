cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6800.24"
  sha256 arm:   "3e840e1481e4a7df69dee0042132df4e5b8d4073c04e3850df7d110ed7c76e57",
         intel: "496e8a1dc8a795c3677151fc6cb55846f4271e51fae786f4e75e46bc474ab564"

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
