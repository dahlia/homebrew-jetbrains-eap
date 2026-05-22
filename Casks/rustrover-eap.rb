cask "rustrover-eap" do
  arch arm: "-aarch64"

  version "2026.2,262.6228.44"
  sha256 arm:   "644a464ffc40bbf3f27bfd18bf3031797a3f6ba4fe6e367ecbf8dbcf356070d1",
         intel: "6be8b9dce865fe98ceb77324d4746200c5aa354fef1b4cd778c9bfc4b58cf2c1"

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
  depends_on :macos

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
