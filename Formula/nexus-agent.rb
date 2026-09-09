class NexusAgent < Formula
  include Language::Python::Virtualenv

  desc "Autonomous local agent runtime"
  homepage "https://github.com/origit892-stack/nexus"
  url "https://github.com/origit892-stack/nexus/releases/download/v1.6.0/nexus-macos-1.6.0.tar.gz"
  sha256 "68036655924dd8408cc3f2b7e957697766afff80b0549b42c17c9317d69a0eec"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(
      libexec,
      formula_opt_bin("python@3.14")/"python3.14",
    )

    wheel = Dir[
      "wheel/nexus-#{version}-*.whl",
    ].first

    odie "Nexus wheel missing" unless wheel

    venv.pip_install wheel

    bin.install_symlink libexec/"bin/nexus"
  end

  test do
    assert_match "Nexus #{version}", shell_output("#{bin}/nexus --version")
  end
end
