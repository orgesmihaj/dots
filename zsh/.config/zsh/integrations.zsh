# ─── integrations.zsh  ────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ fzf integration                                                 ┃
# ┃                                                                 ┃
# ┃ Enables fuzzy search widgets and keybindings in Zsh.            ┃
# ┃ https://github.com/junegunn/fzf                                 ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ zoxide integration                                              ┃
# ┃                                                                 ┃
# ┃ Smart directory jumping; optionally replaces `cd`.              ┃
# ┃ https://github.com/ajeetdsouza/zoxide                           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init --cmd cd zsh)"
fi
