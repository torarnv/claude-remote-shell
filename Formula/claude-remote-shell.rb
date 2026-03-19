class ClaudeRemoteShell < Formula
  desc "Redirect Claude Code's Bash tool commands to a remote machine over SSH"
  homepage "https://github.com/torarnv/claude-remote-shell"
  url "https://github.com/torarnv/claude-remote-shell/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "090ace577fe525027e20ebc8a187d8fd5454367f3bdda93cf4366e2b6da0700a"
  license "MIT"

  depends_on "mutagen-io/mutagen/mutagen"

  def install
    bin.install "claude-remote-shell"
    bin.install_symlink "claude-remote-shell" => "claude-remote-shell-yolo"
  end
end
