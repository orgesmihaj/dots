# ─── core.zsh  ────────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ This file prepares essential environment paths and initializes  ┃
# ┃ core subsystems that other config files depend on. It should be ┃
# ┃ sourced early in .zshrc, before plugins or prompt setup.        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

mkdir -p "$ZDOTDIR/cache"
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ INFO                                                            ┃
# ┃                                                                 ┃
# ┃ Zsh's cached completion state. Other files (completion.zsh)     ┃
# ┃ assume this is set before compinit runs.                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

export ZSH_COMPDUMP="$ZDOTDIR/cache/.zcompdump-$HOST"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ `compinit` must run after `ZSH_COMPDUMP` is defined but before  ┃
# ┃ any plugin that relies on completion. Running it earlier or     ┃
# ┃ multiple times leads to inconsistent completion behavior.       ┃
# ┃                                                                 ┃
# ┃ Note: `compinit -C` skips security checks and speeds up startup.┃
# ┃ If you sync dotfiles across machines or use untrusted plugins,  ┃
# ┃ switch to plain `compinit` instead.                             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

autoload -Uz compinit
compinit -C
