# homebrew-batalert/Formula/batalert-cli.rb
#
# Installation :
#   brew tap elkwaet/batalert https://gitlab.com/elkwaet/homebrew-batalert.git
#   brew install elkwaet/batalert/batalert-cli
#
# Désinstallation :
#   brew uninstall batalert-cli
#   brew untap elkwaet/batalert

class BatalertCli < Formula
  include Language::Python::Virtualenv

  desc "CLI configuration tool for BatAlert — lightweight macOS battery monitor"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/archive/v1.2.0/battery-alert-macos-v1.2.0.tar.gz"
  sha256 "1c5d2f7fbe0a61a644e8ff112d6362f6795eb62e14f9bb462ae380d44c9e34b3"
  license "MIT"
  version "1.3.0"

  depends_on "python@3.12"

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/source/r/rumps/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/source/p/psutil/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  def install
    # Créer un venv isolé avec le Python Homebrew
    python3 = Formula["python@3.12"].opt_bin/"python3.12"
    venv = libexec/"venv"

    system python3, "-m", "venv", "--without-pip", venv

    # Bootstrapper pip dans le venv
    system venv/"bin/python3", "-m", "ensurepip"
    system venv/"bin/python3", "-m", "pip", "install", "--quiet",
           "--upgrade", "pip"

    # Installer les dépendances dans le venv
    system venv/"bin/pip", "install", "--quiet", "rumps", "psutil"

    # Installer batalert.py dans libexec
    libexec.install "batalert.py", "i18n.py"

    # Créer le wrapper shell qui utilise le venv Python
    (bin/"batalert").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/python3" "#{libexec}/batalert.py" "$@"
    SH
    chmod 0755, bin/"batalert"
  end

  def caveats
    <<~EOS
      BatAlert CLI is now installed.

      To launch the menu bar app, install the cask:
        brew install --cask elkwaet/batalert/batalert

      First-time setup:
        batalert --setup

      To start the app:
        open /Applications/BatAlert.app
    EOS
  end

  test do
    assert_match "BatAlert #{version}", shell_output("#{bin}/batalert --version")
  end
end