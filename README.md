# Dots

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each tool lives in its own package directory that mirrors `$HOME`, so Stow can create the symlinks automatically.

## Packages

| Package | Tool | Config path |
|---------|------|-------------|
| `bat` | [bat](https://github.com/sharkdp/bat) | `~/.config/bat/config` |
| `cursor` | [Cursor](https://cursor.sh) | `~/Library/Application Support/Cursor/User/` |
| `ghostty` | [Ghostty](https://ghostty.org) | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| `git` | Git | `~/.gitconfig` |
| `ohmyposh` | [Oh My Posh](https://ohmyposh.dev) | `~/.config/ohmyposh/config.toml` |
| `vscode` | [VS Code](https://code.visualstudio.com) | `~/Library/Application Support/Code/User/` |
| `zsh` | Zsh | `~/.zshenv`, `~/.zprofile`, `~/.zshrc`, `~/.config/zsh/*.zsh` |

The `privacy/` directory is not a Stow package — it contains optional hardening scripts run separately with `--privacy`.

## Requirements

- macOS (the installer enforces this)
- [Homebrew](https://brew.sh) used to install `stow` and all other dependencies
- Git

## Installation

```sh
git clone https://github.com/orgesmihaj/dots ~/.dots
cd ~/.dots
./install.sh
```

The installer will:

1. Verify macOS
2. Install GNU Stow via Homebrew if missing
3. Stow all packages (creates symlinks in `$HOME`)
4. Install Homebrew formulae and casks: `bat`, `fzf`, `zoxide`, `neovim`, `git`, `oh-my-posh`, JetBrainsMono Nerd Font, Ghostty
5. Seed `~/.zshrc.local` if it does not exist
6. Install VS Code and Cursor extensions from each editor's `extensions.txt`

### Flags

| Flag | Description |
|------|-------------|
| `--skip-deps` | Skip Homebrew dependency installation |
| `--restow` | Re-create all symlinks (useful after pulling updates) |
| `--dry-run` | Show what would be done without making any changes |
| `--privacy` | Apply macOS privacy hardening (see below) |
| `-h`, `--help` | Show help |

## Zsh

The shell config is split into focused modules loaded in order from `~/.config/zsh/`:

| Module | Purpose |
|--------|---------|
| `core.zsh` | Cache dirs, `compinit` bootstrap |
| `zinit.zsh` | Plugin manager; loads `zsh-autosuggestions`, `zsh-completions`, `fzf-tab`, `zsh-syntax-highlighting` |
| `completion.zsh` | Completion system options |
| `history.zsh` | History size, deduplication, sharing options |
| `aliases.zsh` | Navigation, file ops, git shortcuts, tool aliases |
| `keybindings.zsh` | Emacs-style line editing, widget bindings |
| `integrations.zsh` | `fzf` shell integration, `zoxide` (`cd` replacement) |
| `prompt.zsh` | Initializes Oh My Posh from `~/.config/ohmyposh/config.toml` |

Machine-specific overrides belong in `~/.zshrc.local`, which is sourced last and is not tracked in Git. The installer seeds an empty copy on first run.

## Privacy hardening

Running `./install.sh --privacy` executes two scripts:

- **`macos.sh`** — disables crash reporters, Siri, Spotlight network lookups, AirDrop, Handoff/Continuity advertising; enables the firewall with stealth mode and logging; locks the screen immediately; clears recent items.
- **`network.sh`** — sets Quad9 DNS (`9.9.9.9` / `149.112.112.112`) on Wi-Fi and Ethernet, flushes the DNS cache, disables mDNS multicast advertisements, and disables the captive portal probe.

## Adding a new package

1. Create a directory named after the tool (e.g. `mytool/`).
2. Inside it, mirror the path as it would appear under `$HOME` (e.g. `mytool/.config/mytool/config`).
3. Add the directory name to `PACKAGES` in `install.sh`. If it requires Homebrew formulae or casks, add them to `DEPS` or `CASKS` as well.

Run `./install.sh --restow` to pick up the new package without reinstalling dependencies.

## Theme

| Context | Choice |
|---------|--------|
| Terminal colorscheme | Catppuccin Mocha |
| Terminal font | JetBrainsMono Nerd Font |
| Prompt | Oh My Posh |
| Editor colorscheme | GitHub Dark Default / GitHub Light Default (auto) |

## License

GPL-3.0 — see [LICENSE](LICENSE).
