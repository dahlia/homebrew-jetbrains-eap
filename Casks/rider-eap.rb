cask "rider-eap" do
  arch arm: "-aarch64"

  version "2023.1-EAP7,231.7864.80"
  sha256 intel: "a0f556e618c46c26d8b173f6105dc461c4fff7312c1b8de6ee74b5093f0336c1",
         arm:   "726575849700630e5fbd6a83baf9c784ff26c57e3e7957f55e27c833485e41c4"

  url "https://download-cdn.jetbrains.com/rider/JetBrains.Rider-#{version.csv.first}-#{version.csv.second}.Checked#{arch}.dmg"
  name "JetBrains Rider EAP"
  desc ".NET IDE (EAP)"
  homepage "https://www.jetbrains.com/rider/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RD&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["RD"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask/rider"
  depends_on macos: ">= :high_sierra"

  app "Rider EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "rider") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/Rider#{version.major_minor}",
    "~/Library/Caches/JetBrains/Rider#{version.major_minor}",
    "~/Library/Logs/JetBrains/Rider#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.rider-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.rider-EAP.savedState",
  ]
end
