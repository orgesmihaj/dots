# ───  prompt.zsh  ──────────────────────────────────────────────────╯

if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  return
fi

if ! command -v oh-my-posh >/dev/null 2>&1; then
  return
fi

local config_path="${XDG_CONFIG_HOME:-$HOME/.config}/ohmyposh/config.toml"

if [[ -f "$config_path" ]]; then
  eval "$(oh-my-posh init zsh --config "$config_path")"
else
  [[ -n "$DOTFILES_DEBUG" ]] && echo "[prompt.zsh] Missing OMP config: $config_path"
fi
