class ClaudeRemoteShell < Formula
  desc "Redirect Claude Code's Bash tool commands to a remote machine over SSH"
  homepage "https://github.com/torarnv/claude-remote-shell"
  url "https://github.com/torarnv/claude-remote-shell/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "1436cde1742c0272d376cf80cc7dfe5829638ec960cb31d630eb31e51826d51a"
  license "MIT"

  depends_on "mutagen-io/mutagen/mutagen"

  def install
    bin.install "claude-remote-shell"
    bin.install_symlink "claude-remote-shell" => "claude-remote-shell-yolo"
  end
end
