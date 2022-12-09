cask "intellij-idea-ce-eap" do
  arch arm: "-aarch64"

  version "2022.3.1,223.8214.16"
  sha256 arm:   "617af4a677c809bf27feafe4b2fb988697800d8bbff296b1166aaac34257699e",
         intel: "682b45c8d72c3f6e5b3c65a98e99bc78e59b688912e03339ce8e7d6c410f37a8"

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
