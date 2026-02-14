# ─── aliases.zsh  ────────────────────────────────────────────────╯

# ─── navigation ───────────────────────────────────────────────────

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# ─── file ops ─────────────────────────────────────────────────────

alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'
alias la='ls -A --color=auto'

# ─── files / content ──────────────────────────────────────────────

alias rm='rm -i'
alias rmf='rm -rf'
alias mv='mv -i'
alias cp='cp -i'

alias duh='du -h -d 1'
alias dusort='du -sh * | sort -hr'

alias README='bat README.md'

# ─── git ──────────────────────────────────────────────────────────

alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gl='git pull'
alias gp='git push'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias glg='git log --oneline --graph --decorate'
alias gst='git status -sb'

# ─── tools ─────────────────────────────────────────────────────────

if command -v nvim >/dev/null; then
  alias vim='nvim'
  alias v='nvim'
fi

alias grep='grep --color=auto'
alias please='sudo $(fc -ln -1)'

# ─── networking / debug ───────────────────────────────────────────

alias myip='curl ifconfig.me'
alias ports='lsof -i -P -n'
alias pingg='ping google.com'

# ─── zsh-specific ─────────────────────────────────────────────────

alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'
alias c='printf "\033c"'
