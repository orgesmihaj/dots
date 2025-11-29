# ───  zinit.zsh  ───────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃  Zinit: Zsh plugin manager                                       ┃ 
# ┃                                                                  ┃
# ┃  Flexible and fast Zsh plugin manager that lets you install      ┃
# ┃  pluginsdirectly from GitHub and many other sources.             ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  if ! command -v git >/dev/null 2>&1; then
    echo "zinit: git not found; cannot install Zinit" >&2
    return
  fi

  mkdir -p "$ZINIT_HOME"
  git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# 🚀
source "$ZINIT_HOME/zinit.zsh"

# ─── plugins ───────────────────────────────────────────────────────

zinit wait lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  Aloxaf/fzf-tab

zinit wait'0' lucid light-mode for \ 
  zsh-users/zsh-syntax-highlighting

