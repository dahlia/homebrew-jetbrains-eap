cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2025.1,251.23774.208"
  sha256 arm:   "fad79b9ef6cb6586340bea207102a424b3a85303441b63dbc940a6dffce0f91c",
         intel: "a6f92fcbed15aa454d53130eeb99f91e8c834bb470791594022272d614b03101"

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
