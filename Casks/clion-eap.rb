cask "clion-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.22158.47"
  sha256 arm:   "cd9247b82341eaf1160934b6adc91cea4b7ea6f9db7d37ae4c56fe0bd3c85b3b",
         intel: "bcf925d1519766f57b1013131b0a563e806c0a09e73f4407184815cd67b3b957"

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
  depends_on macos: ">= :monterey"

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
