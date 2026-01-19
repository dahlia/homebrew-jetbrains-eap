cask "intellij-idea-ce-eap" do
  arch arm: "-aarch64"

  version "2025.2.2,252.26199.7"
  sha256 arm:   "3d25a59b86918a2931ae117396a4d7ff3e1143f6f7ae903ea311211c5ff5ce64",
         intel: "ea0c983aefa3acf19fa9ae0ec32f5e4b74ec66fba344e5876c4534b76bc0c22f"

  url "https://download.jetbrains.com/idea/ideaIC-#{version.csv.second}#{arch}.dmg"
  name "IntelliJ IDEA Community Edition EAP"
  name "IntelliJ IDEA CE EAP"
  desc "IDE for Java development - community edition (EAP)"
  homepage "https://www.jetbrains.com/idea/nextversion/"

  # https://blog.jetbrains.com/idea/2025/12/intellij-idea-unified-release/
  deprecate! date: "2025-12-08", because: :discontinued, replacement_cask: "intellij-idea-eap"

  auto_updates true

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
