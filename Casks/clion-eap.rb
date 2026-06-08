cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.7132.28"
  sha256 arm:   "ce67823bee8b6b85125f102093b52516f8bbe96123b10d411475266022ebf883",
         intel: "89435d37a295425f7e5a92d869d9411194ab4d86cc0ff07fa11d13ba6bf73d85"

  url "https://download.jetbrains.com/cpp/CLion-#{version.csv.second}#{arch}.dmg"
  name "CLion EAP"
  desc "C and C++ IDE (EAP)"
  homepage "https://www.jetbrains.com/clion/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=CL&latest=true&type=eap"
    strategy :json do |json|
      json["CL"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true
  depends_on macos: :monterey

  # The application path is often inconsistent between versions
  rename "CLion*.app", "CLion EAP.app"

  app "CLion EAP.app"
  binary "#{appdir}/CLion EAP.app/Contents/MacOS/clion", target: "clion-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "clion") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/CLion#{version.csv.first}",
    "~/Library/Caches/JetBrains/CLion#{version.csv.first}",
    "~/Library/Logs/JetBrains/CLion#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.CLion-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.CLion-EAP.savedState",
  ]
end
