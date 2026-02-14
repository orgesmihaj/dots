# ─── functions.zsh  ──────────────────────────────────────────────╯

# ─── navigation ───────────────────────────────────────────────────

mkcd() { 
  mkdir -p "$1" && cd "$1" 
}

# ─── keybindings ──────────────────────────────────────────────────

keymap() {
  case "$1" in
    vscode)  bat "$HOME/Library/Application Support/Code/User/keybindings.json" ;;
    cursor)  bat "$HOME/Library/Application Support/Cursor/User/keybindings.json" ;;
    zsh)     bat "${ZDOTDIR:-$HOME/.config/zsh}/keybindings.zsh" ;;
    *)
      echo "Usage: keymap <app>"
      echo "Available: vscode, cursor, zsh"
      ;;
  esac
}

# ─── files / content ──────────────────────────────────────────────

extract() {
  case "$1" in
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.bz2)      tar xjf "$1" ;;
    *.tar.xz)       tar xJf "$1" ;;
    *.zip)          unzip "$1" ;;
    *.rar)          unrar x "$1" ;;
    *) echo "Unsupported file type" ;;
  esac
}
