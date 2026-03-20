# homebrew-batalert/Casks/batalert.rb
#
# Installation :
#   brew tap elkwaet/batalert https://gitlab.com/elkwaet/homebrew-batalert.git
#   brew install --cask elkwaet/batalert/batalert
#
# Désinstallation :
#   brew uninstall --cask batalert

cask "batalert" do
  version "1.3.0"
  sha256 "e1d6dec0d7334934a1c9797bf1f4266afd42aeebeae79a225bb353ce63eabae1"

  # Pointe sur le .app précompilé uploadé comme asset de la release GitLab
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/releases/v#{version}/downloads/BatAlert-#{version}.zip"
  name "BatAlert"
  desc "Lightweight macOS battery monitor with menu bar indicator"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"

  depends_on macos: ">= :monterey"

  # Copie directement BatAlert.app dans /Applications
  # Aucune compilation requise — le .app est déjà buildé
  app "BatAlert.app"

  # Retirer le flag de quarantaine macOS pour eviter le blocage Gatekeeper
  # sur les apps non signees avec un certificat Apple Developer
  postflight do
    system_command "xattr",
                   args: ["-cr", "/Applications/BatAlert.app"],
                   sudo: false
  end

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
      brew install elkwaet/batalert/batalert-cli
  EOS
end
