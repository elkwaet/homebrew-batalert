class BatalertCli < Formula
  include Language::Python::Virtualenv

  desc "CLI configuration tool for BatAlert — lightweight macOS battery monitor"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"
  version "1.7.0"
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/releases/v1.7.0/downloads/BatAlert-1.7.0.zip"
  sha256 "030238d1ba124d0e390c589f565c1134dc95e17f6453c6b7e8cc325b28adfaf7"
  license "MIT"

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
    python3 = Formula["python@3.12"].opt_bin/"python3.12"
    venv = libexec/"venv"

    system python3, "-m", "venv", "--without-pip", venv
    system venv/"bin/python3", "-m", "ensurepip"
    system venv/"bin/python3", "-m", "pip", "install", "--quiet", "--upgrade", "pip"
    system venv/"bin/pip", "install", "--quiet", "rumps", "psutil"

    # buildpath = /private/tmp/batalert-cli-xxx/
    # Le zip extrait y place BatAlert.app/
    resources_path = buildpath/"Contents/Resources"
    libexec.install resources_path/"batalert.py"
    libexec.install resources_path/"i18n.py"
    # Module de configuration introduit en 1.6.0 : absent du ZIP 1.5.x
    config_module = resources_path/"batalert_config.py"
    libexec.install config_module if config_module.exist?

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
