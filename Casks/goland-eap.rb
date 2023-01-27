cask "goland-eap" do
  arch arm: "-aarch64"

  version "2023.1,231.5920.13"
  sha256 intel: "43f1ed2f96ddb948f01c82e0f1680eb9e0be4742e91dfa3133b1a600d657120c",
         arm:   "ab3179cb0f402fc070565e704e27a1bd14d7cc5bc268a043b9d26b287e94af12"

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
  conflicts_with cask: "homebrew/cask/goland"
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
