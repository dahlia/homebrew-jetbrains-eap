cask "goland-eap" do
  arch arm: "-aarch64"

  version "2025.2,252.16512.35"
  sha256 intel: "d40b658e38b9b5c54dfbc24cb92403c43a6ea35adde2bf98faf38d823861a1ab",
         arm:   "6c78fd62d4ac93816ed53b9597ae4afbfc2ab8069f9e0014efa36c4c65d01507"

  url "https://download.jetbrains.com/go/goland-#{version.csv.second}#{arch}.dmg"
  name "GoLand EAP"
  desc "Go (golang) IDE (EAP)"
  homepage "https://www.jetbrains.com/go/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["GO"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "GoLand #{version.major_minor} EAP.app"
  binary "#{appdir}/GoLand #{version.major_minor} EAP.app/Contents/MacOS/goland", target: "goland-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "goland") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/GoLand#{version.major_minor}",
    "~/Library/Caches/JetBrains/GoLand#{version.major_minor}",
    "~/Library/Logs/JetBrains/GoLand#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.goland-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.goland-EAP.SavedState",
  ]
end
