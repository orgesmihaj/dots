# ─── zinit.zsh  ───────────────────────────────────────────────────╯

# Homebrew owns the manager; Zinit keeps plugins in its user data directory.
local zinit_prefix="${HOMEBREW_PREFIX:-}"
if [[ -z "$zinit_prefix" ]]; then
  if [[ -r /opt/homebrew/opt/zinit/zinit.zsh ]]; then
    zinit_prefix=/opt/homebrew
  elif [[ -r /usr/local/opt/zinit/zinit.zsh ]]; then
    zinit_prefix=/usr/local
  fi
fi

if [[ -z "$zinit_prefix" || ! -r "$zinit_prefix/opt/zinit/zinit.zsh" ]]; then
  print -u2 "zinit: not installed; run brew bundle install --file=Brewfile --no-upgrade from the dotfiles repository"
  return 0
fi

source "$zinit_prefix/opt/zinit/zinit.zsh"

# Register completion definitions before completion.zsh runs compinit.
zinit light zsh-users/zsh-completions

# Widgets load after completion initialization and shell integrations.
zinit wait lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  Aloxaf/fzf-tab

zinit wait'0' lucid light-mode for \
  zsh-users/zsh-syntax-highlighting
