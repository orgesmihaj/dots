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

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump"

# completion.zsh initializes completions after Zinit adds definitions.

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ appearance                                                      ┃
# ┃                                                                 ┃
# ┃ Exports APPEARANCE (light or dark) from the macOS setting:      ┃
# ┃ Modus Operandi or Catppuccin Mocha. Rechecked before prompts;   ┃
# ┃ files that theme a tool add a function to appearance_hooks.     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

typeset -ga appearance_hooks

_appearance_update() {
  local appearance=light hook
  [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == Dark ]] && appearance=dark
  [[ "$appearance" == "$APPEARANCE" ]] && return

  export APPEARANCE=$appearance
  export DELTA_FEATURES="appearance-$appearance"
  for hook in $appearance_hooks; do
    $hook
  done
}

_appearance_update
autoload -Uz add-zsh-hook
add-zsh-hook precmd _appearance_update
