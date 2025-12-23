# ─── .zshrc  ──────────────────────────────────────────────────────╯

export ZDOTDIR="$HOME/.config/zsh"

source "$ZDOTDIR/core.zsh"
source "$ZDOTDIR/zinit.zsh"
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/history.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/keybindings.zsh"
source "$ZDOTDIR/integrations.zsh"
source "$ZDOTDIR/prompt.zsh"

# Source local config if it exists (not tracked in git)

if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi