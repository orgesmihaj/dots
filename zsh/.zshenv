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

export SHELL_SESSION_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/sessions"