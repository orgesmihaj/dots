# macOS dotfiles

Application configurations managed with GNU Stow and dependencies declared in
`Brewfile`. Run the commands below from the root of this clone. Homebrew must
already be installed; both Apple Silicon and Intel Macs are supported.

## Install

Deja, the shell's history suggestion tool, comes from a third-party tap.
Homebrew refuses to load formulae from untrusted taps, so review the tap and
trust only its formula before installing:

```sh
brew trust --formula giammarco-ferranti/deja/deja
```

Install missing dependencies without upgrading existing packages:

```sh
brew bundle install --file=Brewfile --no-upgrade
```

This includes Stow, Zinit, Deja, command-line tools (eza, delta, lazygit, gh,
jq, yq, tealdeer, btop, yazi, ouch, vivid), development tools, Ghostty, VS Code,
Cursor, and JetBrainsMono Nerd Font. Download tealdeer's pages once with
`tldr --update`. If Homebrew reports a conflict with a manually installed app,
inspect the existing app and back up anything you need before resolving its
ownership manually and retrying. These instructions do not replace existing apps
automatically.

Preview the links, then apply them after resolving any conflicts:

```sh
stow --simulate bat cursor git ghostty ohmyposh vscode zsh nvim
stow bat cursor git ghostty ohmyposh vscode zsh nvim
```

The root `.stowrc` sets the target to `$HOME`, enables verbose output, disables
directory folding, and excludes generated files. Stow links individual files so
application-created files stay outside the repository. Neovim is included by
default, but its configuration is still in progress.

Stow refuses to overwrite conflicting regular files. Inspect and back up a
conflicting destination before moving it aside and retrying. `--restow` does not
resolve regular-file conflicts. Do not use `--adopt` to bypass them.

Install each editor's extensions explicitly:

```sh
xargs -n 1 code --install-extension < "vscode/Library/Application Support/Code/User/extensions.txt"
xargs -n 1 cursor --install-extension < "cursor/Library/Application Support/Cursor/User/extensions.txt"
```

The Homebrew casks provide these CLI commands. If a command is missing, check
Homebrew's bin directory is on `PATH` before retrying. Each command prints its
own results and returns a failure status when an installation fails. Run both:
Homebrew Bundle's `vscode` entries select one available editor, not both editors.
The extension lists contain one extension ID per line, without comments.

Start a new login shell with `exec zsh -l`. Homebrew installs Zinit itself;
Zinit downloads missing plugins on first use, which requires network access.
Existing Zinit plugin data is reused. An old manually cloned manager is left in
place but is no longer sourced. Missing Zinit produces a warning; standard shell
completion and other configuration still load.

Zinit loads Deja's Zsh plugin, but suggestions need the `deja` binary from the
Brewfile; without it, the plugin prints a warning at startup. Do not add the
activation line from Deja's own Homebrew instructions to `~/.zshrc`, because
Zinit already loads the plugin. Import existing shell history once:

```sh
deja import
```

Deja replaces `zsh-autosuggestions`. Its `DEJA_*` settings must be exported
before Zinit loads the plugin, so `~/.zshrc.local`, which is sourced last, is
too late for them.

## Local preferences

`~/.zshrc.local` is optional and is sourced last. Create it yourself if needed,
keep secrets out of this repository, and use `chmod 600 ~/.zshrc.local` for a
private regular file you own. Installation does not create, overwrite, or change
permissions on this file.

Ghostty requests **MonoLisa Variable** for window titles. It is an optional,
manually installed font; change that setting if you prefer another title font.
JetBrainsMono Nerd Font is installed by the Brewfile for terminal text.

PostgreSQL 18 is optional: its Homebrew bin directory is added to login-shell
`PATH` only when present. Other machine-specific paths belong in local overrides.
mise provides Node: set a global version with `mise use -g node@24` and use
project-level mise configuration when a project needs another version. Laravel
Herd provides PHP. Its `PATH` and INI variables belong in `~/.zshrc.local`.
Herd appends them to `~/.zshrc`, and so to the tracked `zsh/.zshrc`, during
setup and when it installs a PHP version. Move any new `HERD_PHP_*` line to
`~/.zshrc.local` with `$HOME` in place of the home path, then delete Herd's
lines from `zsh/.zshrc`. Earlier versions of the Brewfile installed `node` and
`php`; Homebrew Bundle does not remove them, so run `brew uninstall node php`
yourself if nothing else needs them.

Git's global ignores live in `git/.config/git/ignore`. Project cache exclusions
belong in each project's `.gitignore`. An existing `~/.gitignore` is left intact;
copy any personal patterns you still need into the new global ignore file.
An existing `~/.config/git/ignore` conflicts with the Stow link: merge its
patterns into the repository file and move it aside before stowing `git`.

Git uses delta as its pager and `zdiff3` conflict markers, and enables `rerere`,
pruning on fetch, and auto-stash, auto-squash, and ref updates on rebase.

## Update and remove links

Check dependencies without installing them:

```sh
brew bundle check --file=Brewfile --verbose
```

After pulling changes, repeat the install and extension commands as needed and
preview a restow before applying it:

```sh
stow --simulate --restow bat cursor git ghostty ohmyposh vscode zsh nvim
stow --restow bat cursor git ghostty ohmyposh vscode zsh nvim
```

Use `brew bundle install --file=Brewfile` when you explicitly want Homebrew to
upgrade dependencies. Homebrew is a rolling package manager; `--no-upgrade` does
not pin versions. No cleanup or package removal is part of installation.

Remove a package's links, leaving its source files and installed app intact:

```sh
stow --simulate --delete zsh
stow --delete zsh
```

The former `install.sh` has been removed. Its dependency installation, dry run,
restow, and extension steps are now the direct commands above. Existing Stow
links remain valid because the package layout is unchanged.

## Contributing and validation

Add each application as a lowercase directory mirroring its paths below `$HOME`,
add its dependencies to the Brewfile, and update the package lists above.

Check the Brewfile and parse every shell file separately:

```sh
brew bundle list --file=Brewfile
for file in zsh/.zshenv zsh/.zprofile zsh/.zshrc zsh/.config/zsh/*.zsh; do
  zsh -n "$file" || break
done
```

Use a temporary target with `stow --target=/path/to/temporary-home` to exercise
link creation without installing into your home. For work outside Neovim, use
the package list without `nvim` for these checks.
