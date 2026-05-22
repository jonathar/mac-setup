#!/usr/bin/env bash
set -euo pipefail

REPO="https://github.com/jonathar/mac-setup.git"
CLONE_DIR="$HOME/dev/mac-setup"

info()    { printf "\033[34m[info]\033[0m  %s\n" "$*"; }
success() { printf "\033[32m[ok]\033[0m    %s\n" "$*"; }

mkdir -p "$HOME/dev"

# Xcode CLI tools are required for git
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode CLI tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do sleep 5; done
fi
success "Xcode CLI tools ready"

# Clone or update the repo
if [[ -d "$CLONE_DIR/.git" ]]; then
  info "Repo already exists at $CLONE_DIR — pulling latest..."
  git -C "$CLONE_DIR" pull --ff-only
else
  info "Cloning mac-setup into $CLONE_DIR..."
  git clone "$REPO" "$CLONE_DIR"
fi
success "Repo ready"

exec bash "$CLONE_DIR/install.sh"
