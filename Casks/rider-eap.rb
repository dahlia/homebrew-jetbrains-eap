cask "rider-eap" do
  arch arm: "-aarch64"

  version "2024.2-EAP6,242.19890.25"
  sha256 intel: "7bfbb9ec2aa3519c90e665a1a9d5932c9ec048fe8cc976225dda88c6106463aa",
         arm:   "f2d70b6b9841971cd3387a8c941ea28d17dc28455a5e99735beb3df0ac530e8b"

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
  binary "#{appdir}/Rider EAP.app/Contents/MacOS/rider", target: "rider-eap"

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
