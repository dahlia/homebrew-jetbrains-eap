cask "intellij-idea-eap" do
  arch = on_intel do
    ""
  end
  on_arm do
    "-aarch64"
  end

  version "2022.2.2,222.4167.9"
  sha256 arm:   "03468a792bbbf1d768e66d2672b6edb2c942ba82114ba4ef3320aac36afcf35d",
         intel: "40b3d126624961b26d5d4c41a3a59a5457dfdcb42cfb44ac5cc844a71477ee2f"

  url "https://download.jetbrains.com/idea/ideaIU-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA Ultimate"
  desc "Java IDE by JetBrains"
  homepage "https://www.jetbrains.com/idea/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=eap"
    strategy :page_match do |page|
      JSON.parse(page)["IIU"].map do |release|
        "#{release["version"]},#{release["build"]}"
      end
    end
  end

  auto_updates true
  conflicts_with cask: [
    "homebrew/cask/intellij-idea",
    "homebrew/cask-versions/intellij-idea19",
  ]
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA #{version.major_minor} EAP.app"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "idea") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Caches/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Logs/JetBrains/IntelliJIdea#{version.major_minor}",
    "~/Library/Preferences/com.jetbrains.intellij-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.intellij-EAP.savedState",
  ]
end
