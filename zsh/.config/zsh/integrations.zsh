# ─── integrations.zsh  ────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ fzf integration                                                 ┃
# ┃                                                                 ┃
# ┃ Enables fuzzy search widgets and keybindings in Zsh.            ┃
# ┃ https://github.com/junegunn/fzf                                 ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if command -v fzf >/dev/null 2>&1; then
  # Modus Operandi and Catppuccin Mocha;
  # https://protesilaos.com/emacs/modus-themes-colors
  # https://github.com/catppuccin/fzf
  _appearance_fzf() {
    if [[ "$APPEARANCE" == light ]]; then
      export FZF_DEFAULT_OPTS=" \
        --color=bg+:#DAE5EC,bg:#FFFFFF,spinner:#0031A9,hl:#A60000 \
        --color=fg:#000000,header:#A60000,info:#531AB6,pointer:#0031A9 \
        --color=marker:#0031A9,fg+:#000000,prompt:#531AB6,hl+:#A60000 \
        --color=selected-bg:#CCDFFF \
        --color=border:#9F9F9F,label:#000000"
    else
      export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
        --color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
        --color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
        --color=selected-bg:#45475A \
        --color=border:#6C7086,label:#CDD6F4"
    fi
  }

  _appearance_fzf
  appearance_hooks+=(_appearance_fzf)

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

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ mise integration                                                ┃
# ┃                                                                 ┃
# ┃ Polyglot runtime version manager.                               ┃
# ┃ https://mise.jdx.dev                                            ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
