cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7031.29"
  sha256 arm:   "a041066b98c6d821143bac79ce35a74f460302a39aeb6df1e21b024f0f6b2b8b",
         intel: "f439a8b8b5741dd833a6a97c4aee8df0149b76b4733428fd617d69483ffb8ab0"

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
