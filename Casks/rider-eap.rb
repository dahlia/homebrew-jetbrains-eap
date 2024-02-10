cask "rider-eap" do
  arch arm: "-aarch64"

  version "2024.1-EAP4,241.11761.31"
  sha256 intel: "996a91dca8eafd526fd1979b19021a0d2238f1cbb86924e86894e9de1e27e2dc",
         arm:   "0df379527033f9d211b7cd6c5748a9a6659c2389088979b28cf5432a841c456e"

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
