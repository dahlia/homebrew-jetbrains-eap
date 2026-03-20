cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.1,261.22158.214"
  sha256 arm:   "da7c2d27ae3903987cb20bc4eaf188c7a9ec28cf2236c272e97fc7b9e594b3bf",
         intel: "7401e499533f3a49142ff620c9c6f58c228ca43c3e1de78db0b69b2703b554aa"

  url "https://download.jetbrains.com/rustrover/RustRover-#{version.csv.second}#{arch}.dmg"
  name "RustRover EAP"
  desc "Rust IDE (EAP)"
  homepage "https://www.jetbrains.com/rust/nextversion/"

  livecheck do
    url "https://data.services.jetbrains.com/products/releases?code=RR&latest=true&type=eap"
    strategy :json do |json|
      json["RR"]&.map do |release|
        version = release["version"]
        build = release["build"]
        next if version.blank? || build.blank?

        "#{version},#{build}"
      end
    end
  end

  auto_updates true

  # The application path is often inconsistent between versions
  rename "RustRover*.app", "RustRover EAP.app"

  app "RustRover EAP.app"
  binary "#{appdir}/RustRover EAP.app/Contents/MacOS/rustrover", target: "rustrover-eap"

  uninstall_postflight do
    ENV["PATH"].split(File::PATH_SEPARATOR).map { |path| File.join(path, "rustrover") }.each do |path|
      if File.readable?(path) &&
         File.readlines(path).grep(/# see com.intellij.idea.SocketLock for the server side of this interface/).any?
        File.delete(path)
      end
    end
  end

  zap trash: [
    "~/Library/Application Support/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Caches/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Logs/JetBrains/RustRover#{version.csv.first}",
    "~/Library/Preferences/com.jetbrains.RustRover-EAP.plist",
    "~/Library/Saved Application State/com.jetbrains.RustRover-EAP.savedState",
  ]
end
