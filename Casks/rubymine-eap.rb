cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2025.2,252.18003.33"
  sha256 arm:   "08bcceffc8c7ecae782e20d332cadbeb770f993cde820912aa5be932c33eb746",
         intel: "a90f1ff93b40dcbf5c648bcec02a6a426fc57a663c5b62d29703e385e61ec4d8"

  url "https://download.jetbrains.com/ruby/RubyMine-#{version.csv.second}#{arch}.dmg"
  name "RubyMine EAP"
  desc "Ruby on Rails IDE (EAP)"
  homepage "https://www.jetbrains.com/ruby/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RM&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["RM"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "RubyMine #{version.major_minor} EAP.app"
  binary "#{appdir}/RubyMine #{version.major_minor} EAP.app/Contents/MacOS/rubymine", target: "rubymine-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "mine") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/RubyMine#{version.major_minor}",
    "~/Library/Caches/JetBrains/RubyMine#{version.major_minor}",
    "~/Library/Logs/JetBrains/RubyMine#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.RubyMine-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RubyMine-EAP.savedState",
  ]
end
