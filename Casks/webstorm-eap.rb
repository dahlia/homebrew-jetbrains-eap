cask "webstorm-eap" do
  arch = Hardware::CPU.intel? ? "" : "-aarch64"

  version "2022.2,222.3345.16"

  if Hardware::CPU.intel?
    sha256 "81172a35a7e5dcd11e0f3dcee2509cf56e1658e42fdca61e16867e830337fb89"
  else
    sha256 "eec21b9e09e54bf87ef5aa3391c1d735f5929aa9abe1c3b9c0d35761aa1c260d"
  end

  url "https://download.jetbrains.com/webstorm/WebStorm-#{version.csv.second}#{arch}.dmg"
  name "WebStorm EAP"
  desc "JavaScript IDE (EAP)"
  homepage "https://www.jetbrains.com/webstorm/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=WS&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["WS"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: "homebrew/cask/webstorm"
  depends_on macos: ">= :high_sierra"

  app "WebStorm #{version.major_minor} EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "wstorm") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Caches/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Logs/JetBrains/WebStorm#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.WebStorm-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.WebStorm-EAP.savedState",
  ]
end
