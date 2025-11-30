# ─── completion.zsh  ──────────────────────────────────────────────╯

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
  'm:{a-zA-Z}={A-Za-z}' \              # case-insensitive matching
  'r:|[._-]=**' \                      # treat . _ - as wildcard separators
  'l:|=* r:|=*'                        # "fuzzy-ish" matching on both ends

# ─── colorized completion lists ────────────────────────────────────

if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors \
    "${(s.:.)LS_COLORS}"
fi

# ─── menu behavior ─────────────────────────────────────────────────

zstyle ':completion:*' menu no

# ─── fzf-tab: cd preview ───────────────────────────────────────────

zstyle ':fzf-tab:complete:cd:*' fzf-preview \
  'ls --color=auto $realpath'

# ─── fzf-tab: zoxide preview ────────────────────────────────────────

zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview \
  'ls --color=auto $realpath'
