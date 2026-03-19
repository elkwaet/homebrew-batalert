# homebrew-batalert/Casks/batalert.rb
#
# Installation :
#   brew tap elkwaet/batalert https://gitlab.com/elkwaet/homebrew-batalert.git
#   brew install --cask elkwaet/batalert/batalert
#
# Désinstallation :
#   brew uninstall --cask batalert

cask "batalert" do
  version "1.2.0"
  sha256 "ee61a0669ed7544092d60c1eca89df6a7dd1938d041804ef6fb3f907e71b4ae1"

  # Pointe sur le .app précompilé uploadé comme asset de la release GitLab
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/releases/v#{version}/downloads/BatAlert-#{version}.zip"
  name "BatAlert"
  desc "Lightweight macOS battery monitor with menu bar indicator"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"

  depends_on macos: ">= :monterey"

  # Copie directement BatAlert.app dans /Applications
  # Aucune compilation requise — le .app est déjà buildé
  app "BatAlert.app"

  # Nettoyage complet à la désinstallation
  uninstall quit:   "com.user.batalert",
            delete: "/Applications/BatAlert.app"

  zap trash: [
    "~/Library/Application Support/BatAlert",
    "~/Library/Logs/BatAlert",
    "~/Library/LaunchAgents/com.user.batalert.plist",
    "~/.local/bin/batalert",
  ]

  caveats <<~EOS
    BatAlert has been installed to /Applications/BatAlert.app.

    First-time setup (run once):
      batalert --setup

    Then launch the app:
      open /Applications/BatAlert.app
      -- or via Launchpad / Spotlight

    To also install the CLI configuration tool:
      brew install elkwaet/batalert/batalert
  EOS
end
