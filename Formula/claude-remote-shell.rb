class ClaudeRemoteShell < Formula
  desc "Redirect Claude Code's Bash tool commands to a remote machine over SSH"
  homepage "https://github.com/torarnv/claude-remote-shell"
  url "https://github.com/torarnv/claude-remote-shell/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ee43f29d923a71729b6dfc5fda87dec338eb3064b00012d2b35a779b69674878"
  license "MIT"

  depends_on "mutagen-io/mutagen/mutagen"

  def install
    bin.install "claude-remote-shell"
    bin.install_symlink "claude-remote-shell" => "claude-remote-shell-yolo"
  end
end
