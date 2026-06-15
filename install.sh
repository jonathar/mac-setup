#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dotfiles"

info()    { printf "\033[34m[info]\033[0m  %s\n" "$*"; }
success() { printf "\033[32m[ok]\033[0m    %s\n" "$*"; }
error()   { printf "\033[31m[error]\033[0m %s\n" "$*" >&2; exit 1; }
header()  { printf "\n\033[1;37m%s\033[0m\n" "$*"; }
step()    { printf "  \033[33m%s\033[0m %s\n" "$1" "$2"; }

usage() {
  cat <<EOF
Usage: $(basename "$0") [step]

Steps:
  xcode     Install Xcode CLI tools
  brew      Install Homebrew and run Brewfile
  dotfiles      Symlink dotfiles with GNU Stow
  gh_extensions Install gh CLI extensions
  macos         Apply macOS defaults
  iterm2        Install iTerm2 Tokyo Night profile

Omit step to run everything in order.
EOF
  exit 0
}

# ── Step functions ────────────────────────────────────────────────────────────

step_xcode() {
  if ! xcode-select -p &>/dev/null; then
    info "Installing Xcode CLI tools..."
    xcode-select --install
    until xcode-select -p &>/dev/null; do sleep 5; done
  fi
  success "Xcode CLI tools ready"
}

step_brew() {
  if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Ensure brew is on PATH (required after fresh install on Apple Silicon)
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew ready"

  info "Installing packages from Brewfile..."
  brew bundle --file="$REPO_DIR/Brewfile"
  success "Brewfile done"
}

step_dotfiles() {
  if [[ ! -d "$DOTFILES_DIR" ]] || [[ -z "$(ls -A "$DOTFILES_DIR")" ]]; then
    info "No dotfiles found in $DOTFILES_DIR, skipping stow"
    return
  fi
  info "Symlinking dotfiles..."
  for package in "$DOTFILES_DIR"/*/; do
    name="$(basename "$package")"
    stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$name"
    info "  stowed: $name"
  done
  success "Dotfiles linked"
}

step_gh_extensions() {
  info "Installing gh extensions..."
  gh extension install dlvhdr/gh-dash
  success "gh extensions installed"
}

step_macos() {
  info "Applying macOS defaults..."
  # shellcheck source=macos.sh
  source "$REPO_DIR/macos.sh"
  success "macOS defaults applied"
}

step_iterm2() {
  local divider
  divider="$(printf '%.0s─' {1..60})"

  osascript -e 'display alert "mac-setup" message "Setup is complete. Please read the post-install instructions in your terminal before continuing.\n\nClick OK to import the Tokyo Night color preset into iTerm2." as informational buttons {"OK"} default button "OK"' &>/dev/null || true
  open "$REPO_DIR/iterm2/tokyo-night.itermcolors"

  printf "\n\033[1;37m%s\033[0m\n" "$divider"
  printf "\033[1;37m  iTerm2 — POST-INSTALL STEPS\033[0m\n"
  printf "\033[1;37m%s\033[0m\n\n" "$divider"

  header "  Font"
  step "1." "Open Preferences → Profiles → Text"
  step "2." "Set font to: JetBrainsMono Nerd Font"
  step "3." "Set the same font for Non-ASCII font"
  step "4." "Recommended size: 14pt"

  header "  Tokyo Night colorscheme"
  step "1." "Click OK on the import dialog that just opened"
  step "2." "Open Preferences → Profiles → Colors"
  step "3." "Open the 'Color Presets' dropdown → select 'tokyo-night'"

  printf "\n\033[1;37m%s\033[0m\n\n" "$divider"
}

# ── Entrypoint ────────────────────────────────────────────────────────────────

case "${1:-all}" in
  all)
    step_xcode
    step_brew
    step_dotfiles
    step_gh_extensions
    step_macos
    step_iterm2
    ;;
  xcode)    step_xcode ;;
  brew)     step_brew ;;
  dotfiles)      step_dotfiles ;;
  gh_extensions) step_gh_extensions ;;
  macos)         step_macos ;;
  iterm2)   step_iterm2 ;;
  -h|--help|help) usage ;;
  *) error "Unknown step: '${1}'. Run with --help to see available steps." ;;
esac
