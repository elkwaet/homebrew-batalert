# homebrew-batalert

> Homebrew Tap for [BatAlert](https://gitlab.com/elkwaet/battery-alert-macos) — lightweight macOS battery monitor.

## Install

### App (menu bar) + CLI

```bash
brew tap elkwaet/batalert

# Menu bar app → /Applications/BatAlert.app
brew install --cask elkwaet/batalert/batalert

# CLI configuration tool → batalert command
brew install elkwaet/batalert/batalert
```

### First-time setup

```bash
batalert --setup
open /Applications/BatAlert.app
```

## Update

```bash
brew upgrade --cask elkwaet/batalert/batalert
brew upgrade elkwaet/batalert/batalert-cli
```

## Uninstall

```bash
brew uninstall --cask batalert
brew uninstall batalert-cli
brew untap elkwaet/batalert
```

---

Source : [gitlab.com/elkwaet/battery-alert-macos](https://gitlab.com/elkwaet/battery-alert-macos)
