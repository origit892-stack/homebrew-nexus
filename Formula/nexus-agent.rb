class NexusAgent < Formula
  include Language::Python::Virtualenv

  desc "Autonomous local agent runtime"
  homepage "https://github.com/origit892-stack/nexus"
  url "https://github.com/origit892-stack/nexus/releases/download/v1.6.0/nexus-homebrew-1.6.0-arm64.tar.gz"
  sha256 "50c6112fdfa63c1bc6252e5cb12df50fd97efd916edd18eccd126052a5273058"
  version "1.6.0"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(
      libexec,
      formula_opt_bin("python@3.14")/"python3.14",
      without_pip: false,
    )

    wheels = Dir["wheelhouse/*.whl"].sort
    odie "Nexus wheelhouse missing" if wheels.empty?

    system       venv.root/"bin/python",
      "-m",
      "pip",
      "install",
      "--no-index",
      "--find-links",
      buildpath/"wheelhouse",
      "nexus==#{version}"

    bin.install_symlink libexec/"bin/nexus"
  end

  test do
    assert_match "Nexus #{version}", shell_output("#{bin}/nexus --version")

    system       libexec/"bin/python",
      "-c",
      "import yaml, typer, rich, openai, rapidfuzz, prompt_toolkit, playwright"
  end
end
