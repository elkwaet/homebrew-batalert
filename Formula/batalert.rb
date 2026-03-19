class Batalert < Formula
  desc "Lightweight macOS battery monitor — CLI configuration tool"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/archive/v1.2.0/battery-alert-macos-v1.2.0.tar.gz"
  sha256 "5e40e5d5a29fb5a062f12a35dc33672de900487ddf9c35d24f1eafe02dea7dc7"
  license "MIT"
  version "1.2.0"

  depends_on "python@3.12"

  def install
    # Installer les dependances pip dans un venv isole
    venv = libexec/"venv"
    system Formula["python@3.12"].opt_bin/"python3.12", "-m", "venv", venv
    system venv/"bin/pip", "install", "--quiet", "rumps", "psutil"

    # Installer le script principal
    (bin/"batalert").write <<~SH
      #!/bin/bash
      exec "#{venv}/bin/python" "#{libexec}/batalert.py" "$@"
    SH

    libexec.install "batalert.py"
  end

  def caveats
    <<~EOS
      BatAlert CLI installed. First-time setup:
        batalert --setup

      To launch the menu bar app:
        open /Applications/BatAlert.app
      Or install the full app:
        brew install --cask elkwaet/batalert/batalert
    EOS
  end

  test do
    assert_match "BatAlert #{version}", shell_output("#{bin}/batalert --version")
  end
end
