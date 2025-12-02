# ─── .zshenv  ─────────────────────────────────────────────────────╯

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ WARNING                                                         ┃
# ┃                                                                 ┃
# ┃ `.zshenv` is sourced by every Zsh invocation — interactive,     ┃
# ┃ non-interactive, login, non-login, and script execution.        ┃
# ┃                                                                 ┃
# ┃ Keep it minimal: only universal environment variables that must ┃
# ┃ exist everywhere. Avoid aliases, prompts, plugins, or heavy     ┃
# ┃ logic, which can slow or break scripts and automation.          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

export LANG="en_US.UTF-8"
export PATH="$HOME/.local/bin:/usr/local/bin:$HOME/bin:$PATH"
