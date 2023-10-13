cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2023.3,233.9802.6"
  sha256 arm:   "96a004803fbd36046b6a2239599f0b7ffccd4690ea2f675398213808f3a74306",
         intel: "8a17fb74b5b02b3df6644f62613705706d63095724cf2b9b1c2b6599af7820b0"

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
