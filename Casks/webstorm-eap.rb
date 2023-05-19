cask "webstorm-eap" do
  arch arm: "-aarch64"

  version "2023.2,232.6095.12"
  sha256 intel: "4b76c4057be25702c71a950802a3bb284aa18dea53ca0629fba3d9290c276ee2",
         arm:   "f4991a026191c52014386e0c9cd013b4872fcb6a983bf9a299eb048af15e0333"

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.csv.second}#{arch}.dmg"
  name "WebStorm EAP"
  desc "JavaScript IDE (EAP)"
  homepage "https://www.jetbrains.com/webstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["WS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask/webstorm"
  depends_on macos: ">= :high_sierra"

  app "WebStorm #{version.major_minor} EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "wstorm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Caches/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Logs/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState",
  ]
end
