# Dotfiles

My personal configs, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

```bash
git clone git@github.com:lownpho/dotfiles.git ~/Workspace/dotfiles
cd ~/Workspace/dotfiles
./scripts/install-deps.sh   # install system requirements (apt/dnf/pacman/brew)
./scripts/install.sh        # symlink dotfiles into $HOME
```

## Usage

```bash
./scripts/install.sh              # stow everything
./scripts/install.sh nvim bash    # stow specific packages
./scripts/install.sh -n           # dry-run
./scripts/install.sh -D nvim      # unstow
```
