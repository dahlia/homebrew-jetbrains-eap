cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.3,263.7307.47"
  sha256 arm:   "a2ca286481e7b5b2a6f6d8c1852eda3603dc890c694fb71d4d9d1c55dd157b2a",
         intel: "1505dce60ee1b0502494eea56774b7a61324c60785dacf9b6003f12955657456"

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
