cask "rider-eap" do
  arch arm: "-aarch64"

  version "2022.3-EAP4,223.6646.116"
  sha256 intel: "afcb4ea24eb3c1d3c0dc591845fc9d7f14ed09a52fc0c740fd95def4b595431e",
         arm:   "0d9ac0d7b99adacc14fa0256be61e3216fa84bcbcd3a6cb8a850057cb0eeec0d"

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
