cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.6259.31"
  sha256 arm:   "db8cbe92fac04b8f4fbce1c63e0362f5808feb171d108bf990c6ae8f603e8155",
         intel: "181e6836bbbe2b09ef9d47d2891f6fe9077a5e06149c39a69525abb216740057"

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
