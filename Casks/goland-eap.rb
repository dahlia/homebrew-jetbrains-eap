cask "goland-eap" do
  arch arm: "-aarch64"

  version "2023.3,233.9802.16"
  sha256 intel: "90fb7990c2fdd13ac73c7728ea56f96074ccedfd15bb2d16ef3238f6ac8cef4c",
         arm:   "695ef5a496b79203baf0fc775439e40b3a610f8aadf9b29ca6de17959186e2d3"

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
