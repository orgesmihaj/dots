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

if [ -x /opt/homebrew/bin/brew ] && ! command -v brew >/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
