cask "intellij-idea-ce-eap" do
  arch arm: "-aarch64"

  version "2025.1,251.22821.72"
  sha256 arm:   "18921c0c3160c02640959e1a51ec9c4c1f393c2be57e5b10fd0da50860d55312",
         intel: "a2d3500ea7c5a3cfce4562739a28c0100cd445a98fec0a3c20bce08b95076fcf"

  url "https://download.jetbrains.com/idea/ideaIC-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA Community Edition EAP"
  name "IntelliJ IDEA CE EAP"
  desc "IDE for Java development - community edition (EAP)"
  homepage "https://www.jetbrains.com/idea/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["IIC"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA #{version.major_minor} CE EAP.app"
  binary "#{appdir}/IntelliJ IDEA #{version.major_minor} CE EAP.app/Contents/MacOS/idea", target: "idea-ce-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "idea") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Caches/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Logs/JetBrains/IdeaIC#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.intellij.ce-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij.ce-EAP.savedState",
  ]
end
