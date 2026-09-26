# ─── core.zsh  ────────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ This file prepares essential environment paths and initializes  ┃
# ┃ core subsystems that other config files depend on. It should be ┃
# ┃ sourced early in .zshrc, before plugins or prompt setup.        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ INFO                                                            ┃
# ┃                                                                 ┃
# ┃ Zsh's cached completion state. Other files (completion.zsh)     ┃
# ┃ assume this is set before compinit runs.                        ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump-$HOST"

# completion.zsh initializes completions after Zinit adds definitions.
