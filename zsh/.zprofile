# ─── .zprofile  ───────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ `.zprofile` is sourced for login shells only. It runs after     ┃
# ┃ `.zshenv` and before `.zshrc`.                                  ┃
# ┃                                                                 ┃
# ┃ Use it for environment setup that depends on the system or      ┃
# ┃ session: PATH assembly, Homebrew initialization, language       ┃
# ┃ runtimes, and other one-time shell bootstrapping.               ┃
# ┃                                                                 ┃
# ┃ Avoid interactive behavior (aliases, prompts, key bindings).    ┃
# ┃ Those belong in `.zshrc`.                                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

typeset -U path
path=("$PNPM_HOME" "$HOME/.bun/bin" "$HOME/.local/bin" "$HOME/bin" $path)
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/postgresql@18/bin" ]]; then
  path=("$HOMEBREW_PREFIX/opt/postgresql@18/bin" $path)
fi
export PATH
