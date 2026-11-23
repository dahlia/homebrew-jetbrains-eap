cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.3.1,263.8311.31"
  sha256 arm:   "e8b81560959106ce0b8483904c30301e9737acb9249456f9dfc2ac1315ce150b",
         intel: "9e13a7d5fc37073314d2a466bacdf719f26ccb923564dfdb6f90f2d4eb57f806"

  url "https://download.jetbrains.com/ruby/RubyMine-#{version.csv.second}#{arch}.dmg"
  name "RubyMine EAP"
  desc "Ruby on Rails IDE (EAP)"
  homepage "https://www.jetbrains.com/ruby/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RM&latest=true&type=eap"
    strategy :json do |json|
      json["RM"]&.map do |release|
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
  rename "RubyMine*.app", "RubyMine EAP.app"

  app "RubyMine EAP.app"
  command_wrapper "rubymine-eap",
                  executable: "#{appdir}/RubyMine EAP.app/Contents/MacOS/rubymine"

  uninstall quit: "com.jetbrains.RubyMine-EAP"

  zap trash: [
    "~/Library/Application Support/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Caches/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Logs/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.RubyMine-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RubyMine-EAP.savedState",
  ]
end
