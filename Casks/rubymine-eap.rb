cask "rubymine-eap" do
  arch arm: "-aarch64"

  version "2023.2,232.8660.52"
  sha256 arm:   "9c2912b44078097fc17f79ecce6a0be9d6232185755cd2efe0d930c1f06324ca",
         intel: "b101a254386b21f9871b87055c5e69b93583520e2c69ea2bf949d221a3e152a4"

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
