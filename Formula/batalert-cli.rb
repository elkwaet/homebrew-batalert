# homebrew-batalert/Formula/batalert-cli.rb
#
# Installation :
#   brew tap elkwaet/batalert https://github.com/elkwaet/homebrew-batalert.git
#   brew install elkwaet/batalert/batalert-cli
#
# Désinstallation :
#   brew uninstall batalert-cli
#   brew untap elkwaet/batalert

class BatalertCli < Formula
  include Language::Python::Virtualenv

  desc "CLI configuration tool for BatAlert — lightweight macOS battery monitor"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"

  # Pointe sur le zip statique uploadé comme asset de release GitLab
  # SHA256 stable — ce fichier ne change jamais une fois uploadé
  version "1.3.0"
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/releases/v1.3.0/downloads/BatAlert-1.3.0.zip"
  sha256 "e1d6dec0d7334934a1c9797bf1f4266afd42aeebeae79a225bb353ce63eabae1"
  license "MIT"

  depends_on "python@3.12"

  resource "rumps" do
    url "https://files.pythonhosted.org/packages/source/r/rumps/rumps-0.4.0.tar.gz"
    sha256 "17fb33c21b54b1e25db0d71d1d793dc19dc3c0b7d8c79dc6d833d0cffc8b1596"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/source/p/psutil/psutil-5.9.8.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  def install
    # Le zip contient BatAlert.app — extraire batalert.py et i18n.py
    # Le zip est structuré : BatAlert.app/Contents/Resources/...
    # On cherche batalert.py et i18n.py dans le bundle
    app_resources = Pathname.glob("BatAlert.app/Contents/Resources/lib/python*/").first

    if app_resources
      py_src = app_resources
    else
      # Fallback : chercher à la racine du zip
      py_src = Pathname.pwd
    end

    # Créer un venv isolé
    python3 = Formula["python@3.12"].opt_bin/"python3.12"
    venv = libexec/"venv"

    system python3, "-m", "venv", "--without-pip", venv
    system venv/"bin/python3", "-m", "ensurepip"
    system venv/"bin/python3", "-m", "pip", "install", "--quiet",
           "--upgrade", "pip"
    system venv/"bin/pip", "install", "--quiet", "rumps", "psutil"

    # Copier les scripts Python depuis le bundle
    ["batalert.py", "i18n.py"].each do |f|
      found = Pathname.glob("**/" + f).first
      raise "#{f} not found in zip" unless found
      libexec.install found => f
    end

    # Wrapper shell
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
