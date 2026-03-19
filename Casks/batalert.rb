cask "batalert" do
  version "1.2.0"
  sha256 "5e40e5d5a29fb5a062f12a35dc33672de900487ddf9c35d24f1eafe02dea7dc7"

  url "https://gitlab.com/elkwaet/battery-alert-macos/-/archive/v#{version}/battery-alert-macos-v#{version}.tar.gz"
  name "BatAlert"
  desc "Lightweight macOS battery monitor with menu bar indicator"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"

  depends_on formula: "python@3.12"
  depends_on formula: "librsvg"
  depends_on macos: ">= :mojave"

  preflight do
    system_command "/usr/bin/pip3",
                   args: ["install", "--quiet", "rumps", "psutil", "py2app"],
                   sudo: false
  end

  installer script: {
    executable: "install.sh",
    args:       ["--non-interactive"],
    sudo:       false,
  }

  app "BatAlert.app"

  uninstall quit:   "com.user.batalert",
            delete: "/Applications/BatAlert.app"

  zap trash: [
    "~/Library/Application Support/BatAlert",
    "~/Library/Logs/BatAlert",
    "~/Library/LaunchAgents/com.user.batalert.plist",
    "~/.local/bin/batalert",
  ]

  caveats <<~EOS
    First-time setup:
      batalert --setup
    Then launch:
      open /Applications/BatAlert.app
  EOS
end
