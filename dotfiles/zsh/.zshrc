# ── Homebrew ──────────────────────────────────────────────────────────────────
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Path ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ── Tools ─────────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"

# direnv hook
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# starship prompt
eval "$(starship init zsh)"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls="eza --icons"
alias ll="eza --icons -la"
alias lt="eza --icons --tree --level=2"
alias cat="bat"
alias vim="nvim"
alias lg="lazygit"
alias g="git"
alias '??'='claude -p'

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey '^D' delete-char-or-list

# ── Local overrides (not tracked in git) ──────────────────────────────────────
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

