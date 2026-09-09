class NexusAgent < Formula
  desc "Autonomous local agent runtime"
  homepage "https://github.com/origit892-stack/nexus"
  url "https://github.com/origit892-stack/nexus/releases/download/v1.7.0/nexus-homebrew-1.7.0-arm64.tar.gz"
  sha256 "10ed830e5d3c8e7cf5405478eefdf2f2771d823b8bc6dfd71b394d5c8f26927b"

  depends_on arch: :arm64
  depends_on "python@3.14"

  def install
    wheelhouse = pkgshare/"wheelhouse"
    wheelhouse.install Dir["*.whl"]

    launcher = bin/"nexus"

    launcher.write <<~SH
      #!/bin/bash
      set -euo pipefail

      RUNTIME="#{var}/nexus-agent"
      VENV="$RUNTIME/venv"
      MARKER="$RUNTIME/.nexus-version"
      VERSION="#{version}"
      PYTHON="#{formula_opt_bin("python@3.14")}/python3.14"
      WHEELHOUSE="#{pkgshare}/wheelhouse"

      NEED_BOOTSTRAP=0

      if [ ! -x "$VENV/bin/nexus" ]; then
        NEED_BOOTSTRAP=1
      elif [ ! -f "$MARKER" ]; then
        NEED_BOOTSTRAP=1
      elif [ "$(cat "$MARKER" 2>/dev/null)" != "$VERSION" ]; then
        NEED_BOOTSTRAP=1
      fi

      if [ "$NEED_BOOTSTRAP" -eq 1 ]; then
        mkdir -p "$RUNTIME"
        rm -rf "$VENV"

        "$PYTHON" -m venv "$VENV"

        "$VENV/bin/python" -m pip install           --no-index           --find-links "$WHEELHOUSE"           "nexus==$VERSION"

        "$VENV/bin/python" -m pip check

        printf '%s\n' "$VERSION" > "$MARKER"
      fi

      exec "$VENV/bin/nexus" "$@"
    SH

    chmod 0755, launcher
  end

  test do
    assert_match(
      "Nexus #{version}",
      shell_output("#{bin}/nexus --version"),
    )
  end
end
