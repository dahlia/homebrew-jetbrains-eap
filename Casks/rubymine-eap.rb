cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.5701.34"
  sha256 arm:   "9ab810df52a7020e2633f5498bf7f90389804b8736fc3d3b0677c6baf8b2ec03",
         intel: "3626139ba37519bf9a68833e237fcfd4b3d4893565ee28958086c5e86514f7bf"

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
