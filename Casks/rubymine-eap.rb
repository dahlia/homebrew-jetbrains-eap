cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.7581.17"
  sha256 arm:   "fa8b304b083d4f7e6a0111bef4b6a44c325aea5e3bc9b1c3b1ffa1bfdffc6707",
         intel: "27720ecf6dd3e0f62784b1d52b3fa0dae3f9c99e29a88c14e0b238996dd2d9ad"

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
  binary "#{appdir}/RubyMine EAP.app/Contents/MacOS/rubymine", target: "rubymine-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "mine") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Caches/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Logs/JetBrains/RubyMine#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.RubyMine-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RubyMine-EAP.savedState",
  ]
end
