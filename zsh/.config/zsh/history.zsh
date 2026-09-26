# ─── history.zsh  ────────────────────────────────────────────────╯

HISTSIZE=100000
SAVEHIST=$HISTSIZE

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃ history file location                                          ┃
# ┃                                                                ┃
# ┃ Store history under XDG_STATE_HOME as persistent,              ┃
# ┃ machine-specific state (not config or cache). Keeps $HOME      ┃
# ┃ clean and prevents unintentional syncing.                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

mkdir -p "${HISTFILE:h}"

# ─── history persistence behavior ─────────────────────────────────

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_VERIFY

# ─── filtering / cleaning ─────────────────────────────────────────

setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
