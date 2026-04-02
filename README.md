# claude-remote-shell

A single-script CLI tool that redirects [Claude Code](https://claude.ai/code)'s
Bash tool commands to a remote machine over SSH, with optional bidirectional
file sync via [Mutagen](https://mutagen.io).

- **Free up your local machine** — builds, tests, and long-running shell commands
  execute on the remote, so your laptop stays cool and available for other work
- **Tap into more capable hardware** — point Claude at a beefier server or cloud
  instance without giving up your local editor, MCP tools, or settings
- **No UI lag** — Claude itself and all file operations run locally, so reading,
  editing, and searching code feels instant regardless of remote latency
- **Relax shell permissions** — when the remote is a dedicated VM, unrestricted
  Bash execution carries no risk to your local machine, so you can auto-approve
  all shell commands without hesitation

Inspired by [langwatch/claude-remote](https://github.com/langwatch/claude-remote) ❤️

## Installation

```sh
brew install torarnv/claude-remote-shell/claude-remote-shell
```

## Usage

```sh
# Remote execution only (no project sync)
claude-remote-shell [user@]host

# Remote execution + sync current directory to a path on the remote
claude-remote-shell [user@]host:/path/on/remote

# Pass additional Claude options
claude-remote-shell [user@]host:/path/on/remote --model claude-opus-4-6

# Use a different Claude binary (e.g., a wrapper)
claude-remote-shell some-other-wrapper [user@]host:/path/on/remote
```

Claude launches normally — all Bash tool commands are silently routed to the
remote host. The working directory follows `cd` commands across calls.

## How It Works

Claude Code supports a `CLAUDE_CODE_SHELL` environment variable that replaces
the default shell used for Bash tool execution. `claude-remote-shell` exploits
this to transparently intercept every shell command Claude runs and forward it
to a remote host via SSH — with the same working directory, stdout/stderr, and
exit code.

Only the Bash tool is redirected — all other tools (file edits, writes, MCP
calls, etc.) continue to run locally as normal. This means Claude reads and
writes files on your local machine, but executes shell commands on the remote.

Optionally, it syncs your local project directory to the remote with Mutagen,
flushing before and after each command so both sides stay consistent. If the
local and remote paths differ, paths are automatically translated in both
directions — outbound in commands, inbound in output.

## Project Sync

When a remote path is given (`host:/path`), the current directory is synced
bidirectionally with that path on the remote using Mutagen. The sync is flushed
before each SSH command (local → remote) and after (remote → local).

If the remote path differs from the local path, paths are automatically
translated in both directions: local paths in commands are rewritten to the
remote path before execution, and remote paths in output are rewritten back to
local paths before Claude sees them.

> [!NOTE]
> Path translation only applies to the text of commands and their output — it
> does not rewrite file contents on disk. If your project contains files that
> embed absolute paths (e.g. a git worktree, where the `.git` file contains a
> `gitdir:` pointer to the local absolute path), those will be synced verbatim
> and will be wrong on the remote.

To customize Mutagen sync behavior, create `.claude/remote-shell/mutagen.yml`
in your project directory. If present, it is passed to `mutagen sync create`
via `-c`.

For example, to exclude large directories from syncing:

```yaml
sync:
  defaults:
    ignore:
      paths:
        - "node_modules"
        - ".build"
```

The Mutagen daemon and session are isolated per session (via
`MUTAGEN_DATA_DIRECTORY`) and torn down automatically on exit.

## Permissions

By default, Claude will prompt for approval before running each Bash command. If the remote
is a dedicated VM you trust, you can auto-approve all Bash commands by passing
`--allowedTools "Bash(*)"`:

```sh
claude-remote-shell user@host --allowedTools "Bash(*)"
```

For convenience a `claude-remote-shell-yolo` command is installed alongside
the main command, which auto-approves all Bash commands:

```sh
claude-remote-shell-yolo user@host:/path/on/remote
```

## Alternatives

**Built-in sandbox** (`/sandbox`) constrains what shell commands can do on your
local machine — restricting filesystem writes to defined paths and network
access to approved domains, enforced at the OS level. Everything still runs
locally, so file tools and your editor workflow are unaffected. It is a safety
net for local execution.

**Remote Control** (`claude remote-control`) keeps Claude running on your local
machine but lets you connect to the session from a browser, phone, or another
computer. It is the inverse of remote execution: you are remote, but Claude and
all its tools — Bash, file operations, MCP — still run locally. Use it when you
want to continue an existing local session from another device, not when you
want to offload work to a different machine.

**Running Claude inside a VM** puts everything — Bash, file reads, file writes,
MCP calls — inside the VM. Nothing touches your host machine. This is the most
complete isolation, but it comes with trade-offs: files live inside the VM so
your local editor and file tools lose direct access, and any MCP servers and
Claude settings you rely on must be configured again inside the VM.

**[langwatch/claude-remote](https://github.com/langwatch/claude-remote)** takes
the same remote shell approach, and is what this project was inspired by.
Differences: it falls back to local execution when the remote is unreachable
(which can silently undermine the point of using a remote VM), disables all
permission prompts globally rather than just for Bash, buffers command output
until completion rather than streaming, and is a multi-script suite with a setup
wizard rather than a single file.
