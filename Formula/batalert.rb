class Batalert < Formula
  desc "Lightweight macOS battery monitor — CLI configuration tool"
  homepage "https://gitlab.com/elkwaet/battery-alert-macos"
  url "https://gitlab.com/elkwaet/battery-alert-macos/-/archive/v1.2.0/battery-alert-macos-v1.2.0.tar.gz"
  sha256 "5e40e5d5a29fb5a062f12a35dc33672de900487ddf9c35d24f1eafe02dea7dc7"
  license "MIT"
  version "1.2.0"

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
    virtualenv_install_with_resources
    bin.install "batalert.py" => "batalert"
    inreplace bin/"batalert", %r{^#!/usr/bin/env python3},
              "#!/usr/bin/env #{Formula["python@3.12"].opt_bin}/python3"
  end

  def caveats
    <<~EOS
      BatAlert CLI installed. First-time setup:
        batalert --setup
      To launch the menu bar app:
        open /Applications/BatAlert.app
    EOS
  end

  test do
    assert_match "BatAlert #{version}", shell_output("#{bin}/batalert --version")
  end
end
