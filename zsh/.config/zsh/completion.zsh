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

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path \
  "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"

# ─── matching rules ────────────────────────────────────────────────

zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=**' \
  'l:|=* r:|=*'

# ─── colorized completion lists ────────────────────────────────────

_appearance_ls_colors() {
  if command -v vivid >/dev/null 2>&1; then
    local theme=catppuccin-mocha
    [[ "$APPEARANCE" == light ]] && theme=modus-operandi
    export LS_COLORS="$(vivid generate "$theme")"
  fi

  if [[ -n "$LS_COLORS" ]]; then
    zstyle ':completion:*' list-colors \
      "${(s.:.)LS_COLORS}"
  fi
}

_appearance_ls_colors
appearance_hooks+=(_appearance_ls_colors)

# ─── menu behavior ─────────────────────────────────────────────────

zstyle ':completion:*' menu no

# fzf-tab shows these as group headers; escape sequences are ignored.
zstyle ':completion:*:descriptions' format '[%d]'

# Keep branches in recency order instead of alphabetical.
zstyle ':completion:*:git-(checkout|switch):*' sort false

# ─── fzf-tab: picker ───────────────────────────────────────────────

# Colors come from FZF_DEFAULT_OPTS (integrations.zsh).
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# ─── fzf-tab: directory and file previews ──────────────────────────

local dir_preview='ls --color=always $realpath'
if command -v eza >/dev/null 2>&1; then
  dir_preview='eza -1 --color=always --icons=always $realpath'
fi

local file_preview='head -200 $realpath'
if command -v bat >/dev/null 2>&1; then
  file_preview='bat --color=always --style=numbers --line-range=:200 $realpath'
fi

zstyle ':fzf-tab:complete:cd:*' fzf-preview "$dir_preview"
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview "$dir_preview"
zstyle ':fzf-tab:complete:(nvim|vim|bat|cat|less|head|tail):*' fzf-preview \
  "if [[ -d \$realpath ]]; then $dir_preview; else $file_preview; fi"
unset dir_preview file_preview

# ─── fzf-tab: git previews ─────────────────────────────────────────

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'git diff $word | delta --width=$FZF_PREVIEW_COLUMNS'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
  'git show --color=always $word | delta --width=$FZF_PREVIEW_COLUMNS'
zstyle ':fzf-tab:complete:git-(checkout|switch|log):*' fzf-preview \
  'git log --oneline --graph --color=always -n 50 $word'

# ─── fzf-tab: process and variable previews ────────────────────────

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  'ps -p $word -o command= -ww 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags \
  --preview-window=down:3:wrap

# Previews run in a child shell, so only exported variables show.
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset):*' \
  fzf-preview 'echo ${(P)word}'
