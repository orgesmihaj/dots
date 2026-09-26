# ─── functions.zsh  ──────────────────────────────────────────────╯

# ─── viewing ──────────────────────────────────────────────────────

function _view {
  if command -v bat >/dev/null; then
    bat "$@"
  else
    ${PAGER:-less} "$@"
  fi
}

# ─── navigation ───────────────────────────────────────────────────

function mkcd {
  mkdir -p "$1" && cd "$1"
}

# Open yazi and change to its last directory on exit.
function y {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ─── privileges ───────────────────────────────────────────────────

# Rerun the previous command with sudo, preserving its quoting.
function please {
  local last="$(fc -ln -1)"
  sudo zsh -c "$last"
}

# ─── aliases ──────────────────────────────────────────────────────

function aliases {
  case "$1" in
    zsh)  _view "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh" ;;
    git)  _view "$HOME/.gitconfig" ;;
    *)
      echo "Usage: aliases <app>"
      echo "Available: zsh, git"
      ;;
  esac
}

# ─── keybindings ──────────────────────────────────────────────────

function keymap {
  case "$1" in
    vscode)  _view "$HOME/Library/Application Support/Code/User/keybindings.json" ;;
    cursor)  _view "$HOME/Library/Application Support/Cursor/User/keybindings.json" ;;
    zsh)     _view "${ZDOTDIR:-$HOME/.config/zsh}/keybindings.zsh" ;;
    *)
      echo "Usage: keymap <app>"
      echo "Available: vscode, cursor, zsh"
      ;;
  esac
}

# ─── files / content ──────────────────────────────────────────────

function extract {
  if command -v ouch >/dev/null; then
    ouch decompress "$@"
    return
  fi

  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.rar)          unrar x "$1" ;;
    *) echo "Unsupported file type" ;;
  esac
}
