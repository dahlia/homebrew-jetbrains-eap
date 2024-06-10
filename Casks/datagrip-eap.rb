cask "datagrip-eap" do
  arch arm: "-aarch64"

  version "2024.2,242.15523.28"
  sha256 intel: "525e7e574de59e8eaea7c694d0741f804f494ddc29eedf20ea02a210a354f474",
         arm:   "bef7e05d5177a890d56c24e557f9b39018a179e7dd37482c3696a7e446126e44"

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
