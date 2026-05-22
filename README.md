# mac-setup

Automated macOS development environment setup.

## What's included

- **Homebrew** — package manager, installs everything in `Brewfile`
- **Dotfiles** — managed with GNU Stow, symlinked into `$HOME`
- **macOS defaults** — Finder, Dock, keyboard, trackpad, screenshots
- **iTerm2** — Tokyo Night color scheme

### Dotfiles

| Package | Files |
|---|---|
| `zsh` | `.zshrc` |
| `git` | `.gitconfig`, `.gitignore_global` |
| `tmux` | `.tmux.conf` |
| `nvim` | `.config/nvim/` — lazy.nvim, LSP, Treesitter, Telescope |
| `starship` | `.config/starship.toml` — Tokyo Night preset |

## Usage

On a fresh Mac, run this single command:

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/jonathar/mac-setup/main/bootstrap.sh)
```

This installs Xcode CLI tools if needed, clones the repo to `~/dev/mac-setup`, and runs the full install.

> **Why `bash <(curl ...)` and not `curl ... | bash`?**
> Mainly bc/ Homebrew requires interactive use of user's privilege to install some packages.

### Manual install

If you prefer to clone and run manually:

```sh
git clone https://github.com/jonathar/mac-setup.git ~/dev/mac-setup
cd ~/dev/mac-setup
./install.sh
```

### Running individual steps

Once the repo is cloned:

```sh
./install.sh xcode     # Xcode CLI tools
./install.sh brew      # Homebrew + Brewfile
./install.sh dotfiles  # Symlink dotfiles with stow
./install.sh macos     # macOS system defaults
./install.sh iterm2    # iTerm2 Tokyo Night colorscheme
```

## iTerm2 colorscheme

The `iterm2` step opens the Tokyo Night color preset and prints instructions. Two manual steps are required after:

1. Click **OK** to import the Tokyo Night color preset
2. Open **Preferences → Profiles → Colors** and select `tokyo-night` from the **Color Presets** dropdown

## Machine-local overrides

| File | Purpose |
|---|---|
| `~/.gitconfig.local` | Per-machine git config (name, email, signing key) |
| `~/.zshrc.local` | Per-machine shell config (work aliases, secrets, etc.) |

These files are sourced automatically if they exist — create them on each machine as needed.

## Adding dotfiles

Create a directory under `dotfiles/` mirroring the path from `$HOME`:

```
dotfiles/
└── foo/
    └── .config/
        └── foo/
            └── config.toml   →  symlinked to ~/.config/foo/config.toml
```

Then re-run `./install.sh dotfiles` to stow it.
