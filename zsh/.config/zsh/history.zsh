# ─── history.zsh  ────────────────────────────────────────────────╯

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

mkdir -p "${HISTFILE:h}"

# ─── history persistence behavior ─────────────────────────────────

setopt appendhistory        # Append, don't overwrite
setopt inc_append_history   # Write each command immediately

# ─── filtering / cleaning ─────────────────────────────────────────

setopt hist_ignore_dups     # Ignore consecutive duplicates
setopt hist_ignore_space    # Skip commands starting with space
setopt hist_reduce_blanks   # Trim superfluous whitespace 
