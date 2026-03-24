class ClaudeRemoteShell < Formula
  desc "Redirect Claude Code's Bash tool commands to a remote machine over SSH"
  homepage "https://github.com/torarnv/claude-remote-shell"
  url "https://github.com/torarnv/claude-remote-shell/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "05d7ec7e2fe03c8729db2db1d2d0582d172453520fbb02f298f9b48b179ace20"
  license "MIT"

  depends_on "mutagen-io/mutagen/mutagen"

  def install
    bin.install "claude-remote-shell"
    bin.install_symlink "claude-remote-shell" => "claude-remote-shell-yolo"
  end
end
