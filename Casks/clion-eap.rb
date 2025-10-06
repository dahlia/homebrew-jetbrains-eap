cask "clion-eap" do
  arch arm: "-aarch64"

  version "2025.3,253.24325.50"
  sha256 intel: "be4844361e3c3e1eb3fac1db76517e36d9d50ecc0847e5807e9e6f8ff4f0b010",
         arm:   "72fc307d24e69de72760f8634658553c56ee8346c20f6808772ec05f36d72428"

  url "https://download.jetbrains.com/cpp/CLion-#{version.csv.second}#{arch}.dmg"
  name "CLion EAP"
  desc "C and C++ IDE (EAP)"
  homepage "https://www.jetbrains.com/clion/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["CL"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "CLion #{version.major_minor} EAP.app"
  binary "#{appdir}/CLion #{version.major_minor} EAP.app/Contents/MacOS/clion", target: "clion-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "clion") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/CLion#{version.major_minor}",
    "~/Library/Caches/JetBrains/CLion#{version.major_minor}",
    "~/Library/Logs/JetBrains/CLion#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.CLion-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.CLion-EAP.savedState",
  ]
end
