cask "intellij-idea-ce-eap" do
  arch arm: "-aarch64"

  version "2023.1.1,231.8770.17"
  sha256 arm:   "6126684f2e08a018aa5685136ae69c3a22c72489582a7896bf58adc0af6cdbe4",
         intel: "59fa89a8d10c6ab9f14e6ac95efa6bc00f10a949c9e893dcf171c194baf9ddeb"

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
  conflicts_with cask: [
    "homebrew/cask/intellij-idea-ce",
    "homebrew/cask-versions/intellij-idea-ce19",
  ]
  depends_on macos: ">= :high_sierra"

  app "IntelliJ IDEA #{version.major_minor} CE EAP.app"

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
