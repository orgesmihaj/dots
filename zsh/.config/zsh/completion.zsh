# ─── completion.zsh  ──────────────────────────────────────────────╯

# Zinit loads completion definitions before this module runs.
autoload -Uz compinit
compinit -d "$ZSH_COMPDUMP"

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  CACHE LOCATION                                                 ┃
# ┃                                                                 ┃
# ┃  Persists completion results to disk, reducing latency for      ┃
# ┃  expensive operations (git, kubectl, etc.).                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

zstyle ':completion:*' cache-path \
  "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# ─── matching rules ────────────────────────────────────────────────

zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=**' \
  'l:|=* r:|=*'

# ─── colorized completion lists ────────────────────────────────────

# eza and completion lists share the Catppuccin palette from vivid.
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-mocha)"
fi

if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors \
    "${(s.:.)LS_COLORS}"
fi

# ─── menu behavior ─────────────────────────────────────────────────

zstyle ':completion:*' menu no

# ─── fzf-tab: cd and zoxide previews ───────────────────────────────

local dir_preview='ls --color=always $realpath'
if command -v eza >/dev/null 2>&1; then
  dir_preview='eza -1 --color=always --icons $realpath'
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview "$dir_preview"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview "$dir_preview"
unset dir_preview
