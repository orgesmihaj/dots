# macOS dotfiles

My app configs, linked into place with GNU Stow, with dependencies listed in
`Brewfile`. You'll need Homebrew first. Apple Silicon and Intel Macs both work.
Run everything below from the root of this repo.

## Install

Deja (history suggestions) lives in a third-party tap. Homebrew won't load
formulae from untrusted taps, so take a look at the tap first, then trust just
that formula:

```sh
brew trust --formula giammarco-ferranti/deja/deja
```

Then install whatever's missing, without upgrading what you already have:

```sh
brew bundle install --file=Brewfile --no-upgrade
```

That covers Stow, Zinit, Deja, the CLI tools (eza, delta, lazygit, gh, jq, yq,
tealdeer, btop, yazi, ouch, vivid), dev tools, Ghostty, VS Code, Cursor, and
JetBrainsMono Nerd Font. Run `tldr --update` once to fetch tealdeer's pages.
If Homebrew complains about an app you installed by hand, back up anything you
need, sort out the conflict yourself, and retry. Nothing gets replaced for you.

Next, preview the links and apply them once any conflicts are sorted:

```sh
stow --simulate bat cursor git ghostty ohmyposh vscode zsh nvim
stow bat cursor git ghostty ohmyposh vscode zsh nvim
```

The root `.stowrc` targets `$HOME`, turns on verbose output, disables directory
folding, and skips generated files. Because Stow links individual files, stuff
apps create on their own stays out of the repo. Neovim is included, though its
config is still a work in progress.

Stow won't overwrite existing regular files. If something's in the way, back it
up, move it aside, and try again. `--restow` won't fix that, and please don't
reach for `--adopt` to get around it.

Install editor extensions separately for each editor:

```sh
xargs -n 1 code --install-extension < "vscode/Library/Application Support/Code/User/extensions.txt"
xargs -n 1 cursor --install-extension < "cursor/Library/Application Support/Cursor/User/extensions.txt"
```

The `code` and `cursor` commands come with the Homebrew casks. If one is
missing, make sure Homebrew's bin directory is on your `PATH`. Run both lines,
since Homebrew Bundle's `vscode` entries only target one editor. Each list is
just one extension ID per line.

Finally, start a fresh login shell with `exec zsh -l`. Zinit comes from
Homebrew and pulls in missing plugins on first run, so you'll need a network
connection. Existing plugin data gets reused, and an old hand-cloned Zinit is
left alone but no longer sourced. If Zinit is missing you'll see a warning, but
completion and the rest of the config still load.

### Deja

Zinit loads Deja's Zsh plugin, but it needs the `deja` binary from the Brewfile
(you'll get a startup warning without it). Skip the activation line from Deja's
Homebrew instructions, since Zinit already handles that. Import your existing
history once:

```sh
deja import
```

Deja replaces `zsh-autosuggestions`. Any `DEJA_*` settings have to be exported
before Zinit loads the plugin, so `~/.zshrc.local` is too late for them.

## Local preferences

`~/.zshrc.local` is optional and sourced last. Create it yourself if you want
one, keep secrets there rather than in this repo, and lock it down with
`chmod 600 ~/.zshrc.local`. Nothing here creates or touches it.

Ghostty uses **MonoLisa Variable** for window titles. It's optional and not in
the Brewfile, so change that setting if you'd rather use something else.
Terminal text uses JetBrainsMono Nerd Font, which the Brewfile does install.

PostgreSQL 18 is optional; its bin directory is added to `PATH` only if it
exists. Put other machine-specific paths in your local overrides.

Node comes from mise: set a global version with `mise use -g node@24`, and use a
project-level mise config when something needs a different one. PHP comes from
Laravel Herd, whose `PATH` and INI variables belong in `~/.zshrc.local`. Heads
up: Herd appends them to `~/.zshrc` (so the tracked `zsh/.zshrc`) during setup
and whenever it installs a PHP version. When that happens, move any new
`HERD_PHP_*` line into `~/.zshrc.local`, swap the home path for `$HOME`, and
delete Herd's lines from `zsh/.zshrc`. Older Brewfiles installed `node` and
`php`; Bundle won't remove them, so `brew uninstall node php` if you don't need
them anymore.

Global Git ignores live in `git/.config/git/ignore`; project-specific ones go
in each project's `.gitignore`. An old `~/.gitignore` is left as is, so copy
over any patterns you still want. If you already have `~/.config/git/ignore`,
merge its patterns into the repo's file and move it aside before stowing `git`.

Git uses delta as its pager and `zdiff3` conflict markers, and turns on
`rerere`, pruning on fetch, and auto-stash, auto-squash, and ref updates when
rebasing.

## Updating and removing

Check dependencies without installing anything:

```sh
brew bundle check --file=Brewfile --verbose
```

After pulling changes, rerun the install and extension commands as needed, then
preview and apply a restow:

```sh
stow --simulate --restow bat cursor git ghostty ohmyposh vscode zsh nvim
stow --restow bat cursor git ghostty ohmyposh vscode zsh nvim
```

Want Homebrew to upgrade things too? Drop `--no-upgrade`. Keep in mind Homebrew
is rolling, so `--no-upgrade` doesn't pin versions. Installation never cleans up
or removes packages.

To remove a package's links (source files and installed apps stay put):

```sh
stow --simulate --delete zsh
stow --delete zsh
```

The old `install.sh` is gone; its steps are just the commands above now.
Existing links still work since the package layout hasn't changed.

## Contributing and validation

Add each app as a lowercase directory that mirrors its paths under `$HOME`, add
its dependencies to the Brewfile, and update the package lists above.

To check the Brewfile and parse each shell file:

```sh
brew bundle list --file=Brewfile

for file in zsh/.zshenv zsh/.zprofile zsh/.zshrc zsh/.config/zsh/*.zsh; do
  zsh -n "$file" || break
done
```

To test linking without touching your home directory, point Stow at a temporary
target with `stow --target=/path/to/temporary-home`. If you're not working on
Neovim, leave `nvim` out of the package list for these checks.
