cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2025.2,252.23309.5"
  sha256 intel: "63512859175a1b1dcf0145f9501c2305faf726922cc3b4112338e2ca2e2544b0",
         arm:   "837b372db2e5293fa01100bf979d93b400a5eaa2cb2edc71d235e7d7c2e88fb2"

  url "https://download.jetbrains.com/datagrip/datagrip-#{version.csv.second}#{arch}.dmg"
  name "DataGrip EAP"
  desc "Databases & SQL IDE (EAP)"
  homepage "https://www.jetbrains.com/datagrip/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=DG&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["DG"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "DataGrip #{version.major_minor} EAP.app"
  binary "#{appdir}/DataGrip #{version.major_minor} EAP.app/Contents/MacOS/datagrip", target: "datagrip-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "datagrip") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/DataGrip#{version.major_minor}",
    "~/Library/Caches/JetBrains/DataGrip#{version.major_minor}",
    "~/Library/Logs/JetBrains/DataGrip#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.datagrip-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.datagrip-EAP.savedState",
  ]
end
