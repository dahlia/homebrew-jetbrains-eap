cask "goland-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.20362.30"
  sha256 intel: "647e656ffff4e6c6ae114d6cdbddf8de41be718cea1f273323932b65b534c652",
         arm:   "231af434d8584e138a784186c1096c2af1da5c30e37a48bbc402ae0c5fd7eb6e"

  url "https://download.jetbrains.com/go/goland-#{version.csv.second}#{arch}.dmg"
  name "GoLand EAP"
  desc "Go (golang) IDE (EAP)"
  homepage "https://www.jetbrains.com/go/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=GO&latest=true&type=eap"
    strategy :json do |json|
      json["GO"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "GoLand*.app", "GoLand EAP.app"

  app "GoLand EAP.app"
  binary "#{appdir}/GoLand EAP.app/Contents/MacOS/goland", target: "goland-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "goland") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Caches/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Logs/JetBrains/GoLand#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.goland-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.goland-EAP.SavedState",
  ]
end
