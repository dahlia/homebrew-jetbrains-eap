cask "intellij-idea-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5153.40"
  sha256 arm:   "17750d7bba52f726a415f29d31a35d48ee208a4df5fe8d9402f31a6ddd53b799",
         intel: "365f90500f01fd7ede845d8424675ad51016191a3f437c5ae39e7c2754025751"

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
  binary "#{appdir}/IntelliJ IDEA EAP.app/Contents/MacOS/idea", target: "idea-eap"

  uninstall_postflight_steps do
    remove ["/usr/local/bin/idea", "{{HOMEBREW_PREFIX}}/bin/idea"],
           content_contains: "# see com.intellij.idea.SocketLock for the server side of this interface"
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Caches/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Logs/JetBrains/IntelliJIdea#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.intellij-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij-EAP.savedState",
  ]
end
